/*
Purpose:    共性加工层-存款账户交易明细:包括所有行内存款账户的金融交易明细，数据来源于新核心系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_dep_acct_tran_dtl_change
Createdate: 20200424
Logs:	      20240102 陈伟峰 新增脚本用于更新IP\MAC地址字段
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--drop table ${icl_schema}.cmm_dep_acct_tran_dtl_bak20240517;


-- 2.0 update data to target table
merge into ${icl_schema}.cmm_dep_acct_tran_dtl t1
using (select t.*,row_number() over(partition by global_flow_no order by global_flow_no) as rn
          from (select global_flow_no,ip,mac 
                  from msl.osbs_pub_trade_flow_bak20240607
                 where trim(ip) is not null
                 union all 
                select global_flow_no,ip,mac 
                  from msl.osbs_pub_trade_flow_bak20240531
                 where trim(ip) is not null) t
                 ) t2
on (t1.ova_flow_num =t2.global_flow_no
and t2.rn=1)
when matched then update set t1.client_ip_addr =t2.IP
where t1.etl_dt >=to_date('20230101','yyyymmdd')
and trim(t1.client_ip_addr) is null;
commit;


merge into ${icl_schema}.cmm_dep_acct_tran_dtl t1
using (select t.*,row_number() over(partition by global_flow_no order by global_flow_no) as rn
          from (select global_flow_no,ip,mac 
                  from msl.osbs_pub_trade_flow_bak20240607
                 where trim(MAC) is not null
                 union all 
                select global_flow_no,ip,mac 
                  from msl.osbs_pub_trade_flow_bak20240531
                 where trim(MAC) is not null) t
                 ) t2
on (t1.ova_flow_num =t2.global_flow_no
and t2.rn=1)
when matched then update set t1.cust_termn_mac_addr =t2.MAC
where t1.etl_dt >=to_date('20230101','yyyymmdd')
and trim(t1.cust_termn_mac_addr) is null;
commit;