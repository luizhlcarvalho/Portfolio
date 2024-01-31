```SQL
/*

Limpeza de dados utilizando consultas SQL

*/


SELECT *
FROM dbo.NashvilleHousing 
WHERE PropertyAddress IS NULL

--------------------------------------------------------------------------------------------------------------------------

-- Padronizando formato da data

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM dbo.NashvilleHousing

UPDATE NashvilleHousing 
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing 
ADD SaleDateConverted Date;

UPDATE NashvilleHousing 
SET SaleDateConverted = CONVERT(Date, SaleDate)

--------------------------------------------------------------------------------------------------------------------------

-- Inserindo dados na coluna "PropertyAddress" em que há valores nulos

SELECT * 
FROM dbo.NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE a.PropertyAddress IS NULL

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE a.PropertyAddress IS NULL

--------------------------------------------------------------------------------------------------------------------------

-- Dividindo a coluna "Address" em colunas individuais (Address, City, State)

SELECT PropertyAddress 
FROM dbo.NashvilleHousing


SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM dbo.NashvilleHousing



ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing 
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



SELECT OwnerAddress 
FROM DBO.NashvilleHousing

SELECT 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2), 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM DBO.NashvilleHousing



ALTER TABLE NashvilleHousing 
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



--------------------------------------------------------------------------------------------------------------------------

-- Mudando "Y" e "N" para "Yes" e "No" no campo "Sold as Vacant"

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM dbo.NashvilleHousing nh
GROUP BY SoldAsVacant 
ORDER BY 2

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant 
		 END
FROM dbo.NashvilleHousing nh 



UPDATE NashvilleHousing 
SET SoldAsVacant = 	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant 
		 END;

		 
--------------------------------------------------------------------------------------------------------------------------

-- Removendo duplicatas

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference 
		ORDER BY [UniqueID ]) AS RowNumber
FROM dbo.NashvilleHousing nh )

DELETE
FROM RowNumCTE
WHERE RowNumber > 1


--------------------------------------------------------------------------------------------------------------------------

-- Excluindo colunas não utilizadas

SELECT *
FROM dbo.NashvilleHousing nh 


ALTER TABLE NashvilleHousing 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing 
DROP COLUMN SaleDate
´´´
