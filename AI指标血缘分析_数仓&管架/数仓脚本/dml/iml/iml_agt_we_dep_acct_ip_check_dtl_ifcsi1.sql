/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_we_dep_acct_ip_check_dtl_ifcsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_we_dep_acct_ip_check_dtl_ifcsi1_tm purge;
alter table ${iml_schema}.agt_we_dep_acct_ip_check_dtl add partition p_ifcsi1 values ('ifcsi1')(
        subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_we_dep_acct_ip_check_dtl modify partition p_ifcsi1
    add subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_we_dep_acct_ip_check_dtl_ifcsi1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_name -- 客户姓名
    ,cert_no -- 证件号码
    ,cust_id -- 客户编号
    ,ghb_card_no -- 本行卡号
    ,webank_card_no -- 微众银行卡号
    ,open_ip -- 开户IP
    ,permt_ip -- 常驻IP
    ,check_ip_flg -- 核对IP标志
    ,gd_prov_int_flg -- 广东省内标志
    ,check_tm -- 核对时间
    ,wdraw_flg -- 回撤标志
    ,wdraw_tm -- 回撤时间
    ,wdraw_return_code -- 回撤返回码
    ,wdraw_return_code_descb -- 回撤返回码描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_we_dep_acct_ip_check_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifcs_dep_acct_ip_info-
insert into ${iml_schema}.agt_we_dep_acct_ip_check_dtl_ifcsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_name -- 客户姓名
    ,cert_no -- 证件号码
    ,cust_id -- 客户编号
    ,ghb_card_no -- 本行卡号
    ,webank_card_no -- 微众银行卡号
    ,open_ip -- 开户IP
    ,permt_ip -- 常驻IP
    ,check_ip_flg -- 核对IP标志
    ,gd_prov_int_flg -- 广东省内标志
    ,check_tm -- 核对时间
    ,wdraw_flg -- 回撤标志
    ,wdraw_tm -- 回撤时间
    ,wdraw_return_code -- 回撤返回码
    ,wdraw_return_code_descb -- 回撤返回码描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130032'||p1.ACCT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,p1.NAME -- 客户姓名
    ,p1.CERT_NO -- 证件号码
    ,p1.CUST_ID -- 客户编号
    ,p1.ACCT_ID -- 本行卡号
    ,p1.EXT_CARD_NO -- 微众银行卡号
    ,p1.OPEN_ACCT_IP -- 开户IP
    ,p1.PERMANENT_IP -- 常驻IP
    ,p1.CHECK_IP_FLAG -- 核对IP标志
    ,p1.LOCAL_FLAG -- 广东省内标志
    ,${iml_schema}.timeformat_max2(p1.CHECK_TIME) -- 核对时间
    ,p1.REBACK_FLAG -- 回撤标志
    ,${iml_schema}.timeformat_max2(p1.REBACK_TIME) -- 回撤时间
    ,p1.RETURN_CODE -- 回撤返回码
    ,p1.RETURN_RESULT -- 回撤返回码描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_dep_acct_ip_info' -- 源表名称
    ,'ifcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_dep_acct_ip_info p1
where  1 = 1 
   -- and ${iml_schema}.dateformat_min(substr(p1.CHECK_TIME,1,10)) =to_date('${batch_date}','yyyymmdd')
   and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_we_dep_acct_ip_check_dtl truncate subpartition p_ifcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_we_dep_acct_ip_check_dtl exchange subpartition p_ifcsi1_${batch_date} with table ${iml_schema}.agt_we_dep_acct_ip_check_dtl_ifcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_we_dep_acct_ip_check_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_we_dep_acct_ip_check_dtl_ifcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_we_dep_acct_ip_check_dtl', partname => 'p_ifcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);