/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_mercht_clear_info_h_mrmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_mercht_clear_info_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_mercht_clear_info_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_op purge;
drop table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_stl_way_cd -- 商户结算方式代码
    ,is_supt_auto_clear_flg -- 是否支持自动清算标志
    ,mercht_inst_perds -- 商户分期期数
    ,fix_comm_fee -- 固定手续费
    ,comm_fee_uplmi -- 手续费上限
    ,comm_fee_lolmi -- 手续费下限
    ,fee_rule_cd -- 计费规则代码
    ,mercht_stl_acct_open_bank_no -- 商户结算帐户开户行行号
    ,mercht_stl_acct_open_bank_name -- 商户结算帐户开户行名称
    ,mercht_stl_acct_name -- 商户结算帐户名称
    ,mercht_stl_acct_id -- 商户结算帐户编号
    ,comm_fee_stl_acct_name -- 手续费结算帐户名称
    ,comm_fee_stl_acct_id -- 手续费结算帐户编号
    ,mercht_open_bank_no -- 商户开户行行号
    ,cust_id -- 客户编号
    ,pay_proj_name -- 缴费项目名称
    ,pay_proj_id -- 缴费项目编号
    ,acct_type_cd -- 账户类型代码
    ,resv_field_1 -- 保留字段1
    ,resv_field_2 -- 保留字段2
    ,resv_field_3 -- 保留字段3
    ,resv_idf_1 -- 保留标识1
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_mercht_clear_info_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_mercht_clear_info_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_mercht_clear_info_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_mcht_settle_inf-
insert into ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_tm(
    mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_stl_way_cd -- 商户结算方式代码
    ,is_supt_auto_clear_flg -- 是否支持自动清算标志
    ,mercht_inst_perds -- 商户分期期数
    ,fix_comm_fee -- 固定手续费
    ,comm_fee_uplmi -- 手续费上限
    ,comm_fee_lolmi -- 手续费下限
    ,fee_rule_cd -- 计费规则代码
    ,mercht_stl_acct_open_bank_no -- 商户结算帐户开户行行号
    ,mercht_stl_acct_open_bank_name -- 商户结算帐户开户行名称
    ,mercht_stl_acct_name -- 商户结算帐户名称
    ,mercht_stl_acct_id -- 商户结算帐户编号
    ,comm_fee_stl_acct_name -- 手续费结算帐户名称
    ,comm_fee_stl_acct_id -- 手续费结算帐户编号
    ,mercht_open_bank_no -- 商户开户行行号
    ,cust_id -- 客户编号
    ,pay_proj_name -- 缴费项目名称
    ,pay_proj_id -- 缴费项目编号
    ,acct_type_cd -- 账户类型代码
    ,resv_field_1 -- 保留字段1
    ,resv_field_2 -- 保留字段2
    ,resv_field_3 -- 保留字段3
    ,resv_idf_1 -- 保留标识1
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.MCHT_NO -- 商户编号
    ,'9999' -- 法人编号
    ,P1.SETTLE_TYPE -- 商户结算方式代码
    ,P1.AUTO_STL_FLG -- 是否支持自动清算标志
    ,P1.FEE_FIXED -- 商户分期期数
    ,TO_NUMBER(NVL(TRIM(REGEXP_SUBSTR(P1.FEE_FIXED, '[0-9.]+')),0)) -- 固定手续费
    ,TO_NUMBER(NVL(TRIM(REGEXP_SUBSTR(P1.FEE_MAX_AMT, '[0-9.]+')),0)) -- 手续费上限
    ,TO_NUMBER(NVL(TRIM(REGEXP_SUBSTR(P1.FEE_MIN_AMT, '[0-9.]+')),0)) -- 手续费下限
    ,P1.FEE_RATE -- 计费规则代码
    ,P1.SETTLE_BANK_NO -- 商户结算帐户开户行行号
    ,P1.SETTLE_BANK_NM -- 商户结算帐户开户行名称
    ,P1.SETTLE_ACCT_NM -- 商户结算帐户名称
    ,P1.SETTLE_ACCT -- 商户结算帐户编号
    ,P1.FEE_ACCT_NM -- 手续费结算帐户名称
    ,P1.FEE_ACCT -- 手续费结算帐户编号
    ,P1.OPEN_STLNO -- 商户开户行行号
    ,P1.CHANGE_STLNO -- 客户编号
    ,P1.PAYMNT_STL_PROJ_NM -- 缴费项目名称
    ,P1.PAYMNT_STL_PROJ_NO -- 缴费项目编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.ACCT_TYPE END -- 账户类型代码
    ,P1.MISC_1 -- 保留字段1
    ,P1.MISC_2 -- 保留字段2
    ,P1.MISC_3 -- 保留字段3
    ,P1.MISC_FLAG -- 保留标识1
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_mcht_settle_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_mcht_settle_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCT_TYPE= R1.SRC_CODE_VAL
AND R1.SORC_SYS_CD= 'MRMS'
AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_MCHT_SETTLE_INF'
AND R1.SRC_FIELD_EN_NAME= 'ACCT_TYPE'
AND R1.TARGET_TAB_EN_NAME= 'PTY_MERCHT_CLEAR_INFO_H'
AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_tm 
  	                                group by 
  	                                        mercht_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_cl(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_stl_way_cd -- 商户结算方式代码
    ,is_supt_auto_clear_flg -- 是否支持自动清算标志
    ,mercht_inst_perds -- 商户分期期数
    ,fix_comm_fee -- 固定手续费
    ,comm_fee_uplmi -- 手续费上限
    ,comm_fee_lolmi -- 手续费下限
    ,fee_rule_cd -- 计费规则代码
    ,mercht_stl_acct_open_bank_no -- 商户结算帐户开户行行号
    ,mercht_stl_acct_open_bank_name -- 商户结算帐户开户行名称
    ,mercht_stl_acct_name -- 商户结算帐户名称
    ,mercht_stl_acct_id -- 商户结算帐户编号
    ,comm_fee_stl_acct_name -- 手续费结算帐户名称
    ,comm_fee_stl_acct_id -- 手续费结算帐户编号
    ,mercht_open_bank_no -- 商户开户行行号
    ,cust_id -- 客户编号
    ,pay_proj_name -- 缴费项目名称
    ,pay_proj_id -- 缴费项目编号
    ,acct_type_cd -- 账户类型代码
    ,resv_field_1 -- 保留字段1
    ,resv_field_2 -- 保留字段2
    ,resv_field_3 -- 保留字段3
    ,resv_idf_1 -- 保留标识1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_op(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_stl_way_cd -- 商户结算方式代码
    ,is_supt_auto_clear_flg -- 是否支持自动清算标志
    ,mercht_inst_perds -- 商户分期期数
    ,fix_comm_fee -- 固定手续费
    ,comm_fee_uplmi -- 手续费上限
    ,comm_fee_lolmi -- 手续费下限
    ,fee_rule_cd -- 计费规则代码
    ,mercht_stl_acct_open_bank_no -- 商户结算帐户开户行行号
    ,mercht_stl_acct_open_bank_name -- 商户结算帐户开户行名称
    ,mercht_stl_acct_name -- 商户结算帐户名称
    ,mercht_stl_acct_id -- 商户结算帐户编号
    ,comm_fee_stl_acct_name -- 手续费结算帐户名称
    ,comm_fee_stl_acct_id -- 手续费结算帐户编号
    ,mercht_open_bank_no -- 商户开户行行号
    ,cust_id -- 客户编号
    ,pay_proj_name -- 缴费项目名称
    ,pay_proj_id -- 缴费项目编号
    ,acct_type_cd -- 账户类型代码
    ,resv_field_1 -- 保留字段1
    ,resv_field_2 -- 保留字段2
    ,resv_field_3 -- 保留字段3
    ,resv_idf_1 -- 保留标识1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.mercht_stl_way_cd, o.mercht_stl_way_cd) as mercht_stl_way_cd -- 商户结算方式代码
    ,nvl(n.is_supt_auto_clear_flg, o.is_supt_auto_clear_flg) as is_supt_auto_clear_flg -- 是否支持自动清算标志
    ,nvl(n.mercht_inst_perds, o.mercht_inst_perds) as mercht_inst_perds -- 商户分期期数
    ,nvl(n.fix_comm_fee, o.fix_comm_fee) as fix_comm_fee -- 固定手续费
    ,nvl(n.comm_fee_uplmi, o.comm_fee_uplmi) as comm_fee_uplmi -- 手续费上限
    ,nvl(n.comm_fee_lolmi, o.comm_fee_lolmi) as comm_fee_lolmi -- 手续费下限
    ,nvl(n.fee_rule_cd, o.fee_rule_cd) as fee_rule_cd -- 计费规则代码
    ,nvl(n.mercht_stl_acct_open_bank_no, o.mercht_stl_acct_open_bank_no) as mercht_stl_acct_open_bank_no -- 商户结算帐户开户行行号
    ,nvl(n.mercht_stl_acct_open_bank_name, o.mercht_stl_acct_open_bank_name) as mercht_stl_acct_open_bank_name -- 商户结算帐户开户行名称
    ,nvl(n.mercht_stl_acct_name, o.mercht_stl_acct_name) as mercht_stl_acct_name -- 商户结算帐户名称
    ,nvl(n.mercht_stl_acct_id, o.mercht_stl_acct_id) as mercht_stl_acct_id -- 商户结算帐户编号
    ,nvl(n.comm_fee_stl_acct_name, o.comm_fee_stl_acct_name) as comm_fee_stl_acct_name -- 手续费结算帐户名称
    ,nvl(n.comm_fee_stl_acct_id, o.comm_fee_stl_acct_id) as comm_fee_stl_acct_id -- 手续费结算帐户编号
    ,nvl(n.mercht_open_bank_no, o.mercht_open_bank_no) as mercht_open_bank_no -- 商户开户行行号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.pay_proj_name, o.pay_proj_name) as pay_proj_name -- 缴费项目名称
    ,nvl(n.pay_proj_id, o.pay_proj_id) as pay_proj_id -- 缴费项目编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.resv_field_1, o.resv_field_1) as resv_field_1 -- 保留字段1
    ,nvl(n.resv_field_2, o.resv_field_2) as resv_field_2 -- 保留字段2
    ,nvl(n.resv_field_3, o.resv_field_3) as resv_field_3 -- 保留字段3
    ,nvl(n.resv_idf_1, o.resv_idf_1) as resv_idf_1 -- 保留标识1
    ,case when
            n.mercht_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mercht_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mercht_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.mercht_id = n.mercht_id
            and o.lp_id = n.lp_id
where (
        o.mercht_id is null
        and o.lp_id is null
    )
    or (
        n.mercht_id is null
        and n.lp_id is null
    )
    or (
        o.mercht_stl_way_cd <> n.mercht_stl_way_cd
        or o.is_supt_auto_clear_flg <> n.is_supt_auto_clear_flg
        or o.mercht_inst_perds <> n.mercht_inst_perds
        or o.fix_comm_fee <> n.fix_comm_fee
        or o.comm_fee_uplmi <> n.comm_fee_uplmi
        or o.comm_fee_lolmi <> n.comm_fee_lolmi
        or o.fee_rule_cd <> n.fee_rule_cd
        or o.mercht_stl_acct_open_bank_no <> n.mercht_stl_acct_open_bank_no
        or o.mercht_stl_acct_open_bank_name <> n.mercht_stl_acct_open_bank_name
        or o.mercht_stl_acct_name <> n.mercht_stl_acct_name
        or o.mercht_stl_acct_id <> n.mercht_stl_acct_id
        or o.comm_fee_stl_acct_name <> n.comm_fee_stl_acct_name
        or o.comm_fee_stl_acct_id <> n.comm_fee_stl_acct_id
        or o.mercht_open_bank_no <> n.mercht_open_bank_no
        or o.cust_id <> n.cust_id
        or o.pay_proj_name <> n.pay_proj_name
        or o.pay_proj_id <> n.pay_proj_id
        or o.acct_type_cd <> n.acct_type_cd
        or o.resv_field_1 <> n.resv_field_1
        or o.resv_field_2 <> n.resv_field_2
        or o.resv_field_3 <> n.resv_field_3
        or o.resv_idf_1 <> n.resv_idf_1
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_cl(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_stl_way_cd -- 商户结算方式代码
    ,is_supt_auto_clear_flg -- 是否支持自动清算标志
    ,mercht_inst_perds -- 商户分期期数
    ,fix_comm_fee -- 固定手续费
    ,comm_fee_uplmi -- 手续费上限
    ,comm_fee_lolmi -- 手续费下限
    ,fee_rule_cd -- 计费规则代码
    ,mercht_stl_acct_open_bank_no -- 商户结算帐户开户行行号
    ,mercht_stl_acct_open_bank_name -- 商户结算帐户开户行名称
    ,mercht_stl_acct_name -- 商户结算帐户名称
    ,mercht_stl_acct_id -- 商户结算帐户编号
    ,comm_fee_stl_acct_name -- 手续费结算帐户名称
    ,comm_fee_stl_acct_id -- 手续费结算帐户编号
    ,mercht_open_bank_no -- 商户开户行行号
    ,cust_id -- 客户编号
    ,pay_proj_name -- 缴费项目名称
    ,pay_proj_id -- 缴费项目编号
    ,acct_type_cd -- 账户类型代码
    ,resv_field_1 -- 保留字段1
    ,resv_field_2 -- 保留字段2
    ,resv_field_3 -- 保留字段3
    ,resv_idf_1 -- 保留标识1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_op(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_stl_way_cd -- 商户结算方式代码
    ,is_supt_auto_clear_flg -- 是否支持自动清算标志
    ,mercht_inst_perds -- 商户分期期数
    ,fix_comm_fee -- 固定手续费
    ,comm_fee_uplmi -- 手续费上限
    ,comm_fee_lolmi -- 手续费下限
    ,fee_rule_cd -- 计费规则代码
    ,mercht_stl_acct_open_bank_no -- 商户结算帐户开户行行号
    ,mercht_stl_acct_open_bank_name -- 商户结算帐户开户行名称
    ,mercht_stl_acct_name -- 商户结算帐户名称
    ,mercht_stl_acct_id -- 商户结算帐户编号
    ,comm_fee_stl_acct_name -- 手续费结算帐户名称
    ,comm_fee_stl_acct_id -- 手续费结算帐户编号
    ,mercht_open_bank_no -- 商户开户行行号
    ,cust_id -- 客户编号
    ,pay_proj_name -- 缴费项目名称
    ,pay_proj_id -- 缴费项目编号
    ,acct_type_cd -- 账户类型代码
    ,resv_field_1 -- 保留字段1
    ,resv_field_2 -- 保留字段2
    ,resv_field_3 -- 保留字段3
    ,resv_idf_1 -- 保留标识1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mercht_id -- 商户编号
    ,o.lp_id -- 法人编号
    ,o.mercht_stl_way_cd -- 商户结算方式代码
    ,o.is_supt_auto_clear_flg -- 是否支持自动清算标志
    ,o.mercht_inst_perds -- 商户分期期数
    ,o.fix_comm_fee -- 固定手续费
    ,o.comm_fee_uplmi -- 手续费上限
    ,o.comm_fee_lolmi -- 手续费下限
    ,o.fee_rule_cd -- 计费规则代码
    ,o.mercht_stl_acct_open_bank_no -- 商户结算帐户开户行行号
    ,o.mercht_stl_acct_open_bank_name -- 商户结算帐户开户行名称
    ,o.mercht_stl_acct_name -- 商户结算帐户名称
    ,o.mercht_stl_acct_id -- 商户结算帐户编号
    ,o.comm_fee_stl_acct_name -- 手续费结算帐户名称
    ,o.comm_fee_stl_acct_id -- 手续费结算帐户编号
    ,o.mercht_open_bank_no -- 商户开户行行号
    ,o.cust_id -- 客户编号
    ,o.pay_proj_name -- 缴费项目名称
    ,o.pay_proj_id -- 缴费项目编号
    ,o.acct_type_cd -- 账户类型代码
    ,o.resv_field_1 -- 保留字段1
    ,o.resv_field_2 -- 保留字段2
    ,o.resv_field_3 -- 保留字段3
    ,o.resv_idf_1 -- 保留标识1
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_bk o
    left join ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_op n
        on
            o.mercht_id = n.mercht_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_cl d
        on
            o.mercht_id = d.mercht_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_mercht_clear_info_h;
--alter table ${iml_schema}.pty_mercht_clear_info_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_mercht_clear_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_mercht_clear_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_mercht_clear_info_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_mercht_clear_info_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_cl;
alter table ${iml_schema}.pty_mercht_clear_info_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_mercht_clear_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_op purge;
drop table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_mercht_clear_info_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_mercht_clear_info_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
