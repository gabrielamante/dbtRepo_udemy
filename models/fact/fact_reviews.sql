{{ config(
    materialized = 'incremental',
    on_schema_change = 'fail')
}}

WITH stg_reviews AS (
    SELECT * FROM {{ ref('stg_reviews') }}
)

SELECT {{ dbt_utils.surrogate_key('listing_id', 'review_date', 'reviewer_name', 'review_text') }} as review_id
    , *
FROM stg_reviews
WHERE review_text is not null

{% if is_incremental() %}
    AND review_date > (SELECT max(review_date) from {{ this }})
{% endif %}