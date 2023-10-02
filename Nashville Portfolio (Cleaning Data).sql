SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

SELECT SaleDate, CONVERT(Date, SaleDate) 
FROM PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


---- Populate Property Address
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
-- WHERE PropertyAddress is Null
Order by ParcelID

--- Usando PARCELID podemos ver, que por tener el mismo id tendrian la misma dirección 
---Los que estan sin dirección y con el mismo parcel ID podemos rellenar la dirección 

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null


--- Breaking out Adress into individual Columns (Adress, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
-- WHERE PropertyAddress is Null
-- Order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', Propertyaddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, Len(PropertyAddress)) as Address

FROM PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAdress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', Propertyaddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, Len(PropertyAddress))

SELECT * FROM PortfolioProject.dbo.NashvilleHousing

---- Otra forma de poder separar las , utilizando PARSENAME

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

exec sp_rename 'NashvilleHousing.PropertySplitAdress', 'PropertySplitAddress', 'COLUMN'


--Change Y and N to Yes and No in 'Sold as Vacant' Field


SELECT Distinct(Soldasvacant), Count(SoldasVacant)
FROM PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
ORDer by 2

SELECT SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldasVacant = 'N' Then 'No'
ELSE SoldasVacant
END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldasVacant = 'N' Then 'No'
ELSE SoldasVacant
END

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
FROM PortfolioProject.dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE Row_num > 1
ORDER BY PropertyADdress

-- DELETE UNUSED COLUMNS

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

SELECT *
From PortfolioProject.dbo.NashvilleHousing









