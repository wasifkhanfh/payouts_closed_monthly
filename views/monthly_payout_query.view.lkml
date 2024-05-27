
view: monthly_payout_query {
  derived_table: {
    sql: select
    r.ref_number as 'memo_id',
    DATE(r.create_date) AS 'create date',
    DATE(b.booking_date) AS 'booking date',
    rab.booking_id,
    DATE(r.resolve_date),
    DATE(raf.date_of_error)  as 'date_of_error',
       CASE
           when b.site_id = '1' then 'FlightHub'
           when b.site_id = '4' then 'JustFly'
           else 'error'
        END AS website,
       #raf.fop,
       r.currency,
        r.amount,
       CASE
        WHEN b.currency = 'USD'
        THEN ROUND(r.amount * usd_cad, 2)
        ELSE ROUND(r.amount, 2)
       END AS 'CAD amount',
       raf.form_type,
       r.error_source,
       concat(a.first_name, ' ', a.last_name)   as 'agent_name',
       concat(a2.first_name, ' ', a2.last_name) as 'agent_responsible_for_error',
       r.team,
       r.third_party_charge,
       r.third_party,
       r.source,
       r.am_status,
       r.am_type,
       #r.win_lost_date,
       r.am_cause,
       r.error_cause,
       b.validating_carrier,
       b.gds 'GDS', b.gds_account_id,
       r.reason
FROM respro_am r
         JOIN respro_am_bookings rab on r.id = rab.am_id
         JOIN respro_am_forms raf on r.id = raf.am_id
         JOIN bookings b on rab.booking_id = b.id
         left join booking_tasks bt on raf.task_id = bt.id
         left JOIN agents a ON a.id = bt.created_by
         left join agents a2 on a2.id = r.error_creator_agent
        JOIN currency_rates_history curr on curr.date_rated = date(booking_date)
WHERE
    r.resolve_date BETWEEN CURRENT_DATE - INTERVAL 360 DAY AND CURRENT_DATE
ORDER BY r.amount DESC ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: memo_id {
    type: string
    sql: ${TABLE}.memo_id ;;
  }

  dimension: create_date {
    type: date
    label: "create date"
    sql: ${TABLE}.`create date` ;;
  }

  dimension: booking_date {
    type: date
    label: "booking date"
    sql: ${TABLE}.`booking date` ;;
  }

  dimension: booking_id {
    type: number
    sql: ${TABLE}.booking_id ;;
  }

  dimension: dater_resolve_date {
    type: date
    sql: ${TABLE}.`DATE(r.resolve_date)` ;;
  }

  dimension: date_of_error {
    type: date
    sql: ${TABLE}.date_of_error ;;
  }

  dimension: website {
    type: string
    sql: ${TABLE}.website ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: form_type {
    type: string
    sql: ${TABLE}.form_type ;;
  }

  dimension: error_source {
    type: string
    sql: ${TABLE}.error_source ;;
  }

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension: agent_responsible_for_error {
    type: string
    sql: ${TABLE}.agent_responsible_for_error ;;
  }

  dimension: team {
    type: string
    sql: ${TABLE}.team ;;
  }

  dimension: third_party_charge {
    type: number
    sql: ${TABLE}.third_party_charge ;;
  }

  dimension: third_party {
    type: string
    sql: ${TABLE}.third_party ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: am_status {
    type: string
    sql: ${TABLE}.am_status ;;
  }

  dimension: am_type {
    type: string
    sql: ${TABLE}.am_type ;;
  }

  dimension: am_cause {
    type: string
    sql: ${TABLE}.am_cause ;;
  }

  dimension: error_cause {
    type: string
    sql: ${TABLE}.error_cause ;;
  }

  dimension: validating_carrier {
    type: string
    sql: ${TABLE}.validating_carrier ;;
  }

  dimension: gds {
    type: string
    sql: ${TABLE}.GDS ;;
  }

  dimension: gds_account_id {
    type: string
    sql: ${TABLE}.gds_account_id ;;
  }

  dimension: reason {
    type: string
    sql: ${TABLE}.reason ;;
  }

  set: detail {
    fields: [
        memo_id,
  create_date,
  booking_date,
  booking_id,
  dater_resolve_date,
  date_of_error,
  website,
  currency,
  amount,
  form_type,
  error_source,
  agent_name,
  agent_responsible_for_error,
  team,
  third_party_charge,
  third_party,
  source,
  am_status,
  am_type,
  am_cause,
  error_cause,
  validating_carrier,
  gds,
  gds_account_id,
  reason
    ]
  }
}
