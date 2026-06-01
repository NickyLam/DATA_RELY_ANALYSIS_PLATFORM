/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_finc_divd_dtl_ifmsi1
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
drop table ${iml_schema}.evt_finc_divd_dtl_ifmsi1_tm purge;
alter table ${iml_schema}.evt_finc_divd_dtl add partition p_ifmsi1 values ('ifmsi1')(
        subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_finc_divd_dtl modify partition p_ifmsi1
    add subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_divd_dtl_ifmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,belong_org_id -- 所属机构编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,divd_base -- 分红基数
    ,corp_divd -- 单位分红
    ,divd_way_cd -- 分红方式代码
    ,bonus_tot_amt -- 红利总金额
    ,curr_cd -- 币种代码
    ,actl_bonus -- 实发红利
    ,eqty_rgst_dt -- 权益登记日期
    ,divd_dt -- 分红日期
    ,ex_righ_dt -- 除权日期
    ,aft_tran_lot -- 交易后份额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_finc_divd_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifms_tbhisdivdetail-
insert into ${iml_schema}.evt_finc_divd_dtl_ifmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,bus_cd -- 业务代码
    ,tran_org_id -- 交易机构编号
    ,belong_org_id -- 所属机构编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,finc_acct_id -- 理财账户编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,divd_base -- 分红基数
    ,corp_divd -- 单位分红
    ,divd_way_cd -- 分红方式代码
    ,bonus_tot_amt -- 红利总金额
    ,curr_cd -- 币种代码
    ,actl_bonus -- 实发红利
    ,eqty_rgst_dt -- 权益登记日期
    ,divd_dt -- 分红日期
    ,ex_righ_dt -- 除权日期
    ,aft_tran_lot -- 交易后份额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104004'||P1.CFM_DATE||P1.CFM_NO||P1.TA_CODE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.PRD_CODE -- 产品编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.CFM_NO -- TA确认流水号
    ,P1.BUSIN_CODE -- 业务代码
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.CLIENT_NO -- 交易客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.TOT_VOL -- 分红基数
    ,P1.DIV_PER_UNIT -- 单位分红
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,P1.TOT_DIV_AMT -- 红利总金额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,P1.CFM_AMT -- 实发红利
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.REG_DATE)) -- 权益登记日期
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.DIV_DATE)) -- 分红日期
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.XR_DATE)) -- 除权日期
    ,P1.POST_VOL -- 交易后份额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbhisdivdetail' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbhisdivdetail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBHISDIVDETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_FINC_DIVD_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURR_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_TBHISDIVDETAIL'
        AND R2.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_FINC_DIVD_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where  1 = 1 
    and p1.cfm_date = ${batch_date}
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_finc_divd_dtl truncate subpartition p_ifmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_finc_divd_dtl exchange subpartition p_ifmsi1_${batch_date} with table ${iml_schema}.evt_finc_divd_dtl_ifmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_finc_divd_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_finc_divd_dtl_ifmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_finc_divd_dtl', partname => 'p_ifmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);