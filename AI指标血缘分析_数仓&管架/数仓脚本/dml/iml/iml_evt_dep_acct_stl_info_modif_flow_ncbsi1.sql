/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dep_acct_stl_info_modif_flow_ncbsi1
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
drop table ${iml_schema}.evt_dep_acct_stl_info_modif_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_dep_acct_stl_info_modif_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dep_acct_stl_info_modif_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_acct_stl_info_modif_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,acct_id -- 账户编号
    ,bind_oper_type_cd -- 绑定操作类型代码
    ,tran_stl_id -- 交易结算编号
    ,stl_cust_id -- 结算客户编号
    ,hxb_stl_flg -- 我行结算标志
    ,stl_org_id -- 结算机构编号
    ,stl_acct_id -- 结算账户编号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,cust_id -- 客户编号
    ,tran_teller_id -- 交易柜员编号
    ,last_charge_dt -- 上一收费日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_tm -- 交易时间
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,open_acct_bank_fin_inst_id -- 开户银行金融机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dep_acct_stl_info_modif_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_acct_settle_hist-1
insert into ${iml_schema}.evt_dep_acct_stl_info_modif_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,acct_id -- 账户编号
    ,bind_oper_type_cd -- 绑定操作类型代码
    ,tran_stl_id -- 交易结算编号
    ,stl_cust_id -- 结算客户编号
    ,hxb_stl_flg -- 我行结算标志
    ,stl_org_id -- 结算机构编号
    ,stl_acct_id -- 结算账户编号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,cust_id -- 客户编号
    ,tran_teller_id -- 交易柜员编号
    ,last_charge_dt -- 上一收费日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_tm -- 交易时间
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,open_acct_bank_fin_inst_id -- 开户银行金融机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101052'||P1.SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 流水号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.ACCT_SETTLE_OPERATE_TYPE -- 绑定操作类型代码
    ,P1.SETTLE_NO -- 交易结算编号
    ,P1.SETTLE_CLIENT -- 结算客户编号
    ,DECODE(P1.SETTLE_BANK_FLAG,'I','1','O','0') -- 我行结算标志
    ,P1.SETTLE_BRANCH -- 结算机构编号
    ,P1.SETTLE_ACCT_INTERNAL_KEY -- 结算账户编号
    ,P1.SETTLE_BASE_ACCT_NO -- 结算客户账号
    ,P1.SETTLE_ACCT_CCY -- 结算账户币种代码
    ,P1.SETTLE_ACCT_SEQ_NO -- 结算账户子账号
    ,P1.SETTLE_ACCT_NAME -- 结算账户名称
    ,P1.SETTLE_PROD_TYPE -- 结算账户产品编号
    ,P1.SETTLE_MOBILE_PHONE -- 结算账户绑定手机号码
    ,P1.OLD_SETTLE_BASE_ACCT_NO -- 原利息入账客户账号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.dateformat_max2(P1.LAST_CHARGE_DATE) -- 上一收费日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.SETTLE_ACCT_CLASS -- 结算账户分类代码
    ,P1.BIND_ACCT_BRANCH -- 开户银行金融机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_settle_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_settle_hist p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_dep_acct_stl_info_modif_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dep_acct_stl_info_modif_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_dep_acct_stl_info_modif_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dep_acct_stl_info_modif_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dep_acct_stl_info_modif_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dep_acct_stl_info_modif_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);