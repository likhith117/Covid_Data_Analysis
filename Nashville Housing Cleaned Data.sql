/****** Script for SelectTopNRows command from SSMS  ******/
select *
from [PP Data Cleaning]..[Nashville House ]

select SaleDate,CONVERT(Date,SaleDate) as Date
from [PP Data Cleaning]..[Nashville House ]

update [Nashville House ]
set SaleDate=CONVERT(Date,SaleDate)


Alter table [dbo].[Nashville House]
Add SaleDateConverted date;

update [Nashville House ]
set SaleDateConverted =convert(Date,SaleDate);

select *
from [PP Data Cleaning]..[Nashville House ]
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.propertyaddress,b.PropertyAddress)
from [PP Data Cleaning]..[Nashville House ] a
join [PP Data Cleaning]..[Nashville House ] b
          on a.ParcelID=b.ParcelID
		  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [PP Data Cleaning]..[Nashville House ] a
join [PP Data Cleaning]..[Nashville House ] b
          on a.ParcelID=b.ParcelID
		  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



select PropertyAddress
from [PP Data Cleaning]..[Nashville House ]
--where PropertyAddress is null
order by ParcelID

select
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,charindex(',',PropertyAddress) +1,LEN(PropertyAddress)) as Address
From [PP Data Cleaning]..[Nashville House ]

Alter table [dbo].[Nashville House]
Add PropertySplitAddress nvarchar(255);

update [Nashville House ]
set PropertySplitAddress =SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1);


Alter table [dbo].[Nashville House]
Add PropertySplitCity nvarchar(255);

update [Nashville House ]
set PropertySplitCity=SUBSTRING(PropertyAddress,charindex(',',PropertyAddress) +1,LEN(PropertyAddress))


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [PP Data Cleaning]..[Nashville House ]

ALTER TABLE [Nashville House ]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville House ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Nashville House ]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville House ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Nashville House ]
Add OwnerSplitState Nvarchar(255);

Update [Nashville House ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [PP Data Cleaning]..[Nashville House ]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [PP Data Cleaning]..[Nashville House ]

Update [PP Data Cleaning]..[Nashville House ]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [PP Data Cleaning]..[Nashville House ]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
