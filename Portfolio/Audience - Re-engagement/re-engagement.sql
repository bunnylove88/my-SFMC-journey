SELECT
    c.SubscriberKey,
    c.EmailAddress,
    r.TotalAmount
FROM Customers as c

/* Subquery - Calculate Purchase Value */
LEFT JOIN (
    SELECT 
        SubscriberKey, 
        SUM(Amount) as TotalAmount
    FROM Orders
    WHERE PurchaseDate >= DATEADD(day, -90, GETDATE())
    GROUP BY SubscriberKey
) as r 
ON c.SubscriberKey = r.SubscriberKey

/* Data view join - suppress recent openers */
LEFT JOIN _Open as o
ON c.SubscriberKey = o.SubscriberKey
AND o.EventDate > DATEADD(day, -30, GETDATE())

WHERE c.Status = 'Active'
AND c.TotalLTV > 500
AND o.SubscriberKey is null