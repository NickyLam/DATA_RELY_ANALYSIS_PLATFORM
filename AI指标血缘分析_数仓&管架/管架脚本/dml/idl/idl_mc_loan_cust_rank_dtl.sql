with sum_total as (
select
    sum(t1.dkqmye) as total
from
    iol.pams_jxbb_khftpcl t1
where
    t1.etl_dt = date '2025-08-31'
    and t1.zhbs='1'
    and t1.dkqmye>0
)
select
    t1.khh,
    t1.khmc,
    decode(t1.zhbs,'1','001','2','002'),
    t2.jgdh,
    t2.JGMC,
    t3.BRCH_ID,
    t3.BRCH_name,
    sum(t1.dkqmye),
    round(sum(t1.dkqmye)/(select total from sum_total),6) as loan_avg
from
    iol.pams_jxbb_khftpcl t1
    left join iol.pams_khdx_jg t2 on t1.ssjgkhdxdh = t2.khdxdh
    and t2.start_dt <= date '2025-08-31'
    and t2.end_dt > date '2025-08-31'
    left join icl.cmm_intnal_org_info t3 on t2.jgdh=t3.org_id
    and t3.etl_dt=date'2025-08-31'
where
    t1.etl_dt = date '2025-08-31'
    and t1.zhbs='1'
    and t1.dkqmye>0
group by
    t1.khh,
    t1.khmc,
    decode(t1.zhbs,'1','001','2','002'),
    t2.jgdh,
    t2.JGMC,
    t3.BRCH_ID,
    t3.BRCH_name
