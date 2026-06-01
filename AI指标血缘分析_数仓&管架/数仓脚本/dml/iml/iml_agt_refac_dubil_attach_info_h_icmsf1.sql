/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_refac_dubil_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_refac_dubil_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_refac_dubil_attach_info_h partition for ('icmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,batch_pkg_id -- 批次包编号
    ,cert_name -- 证件名称
    ,cert_no -- 证件号码
    ,cust_type_cd -- 客户类型代码
    ,dubil_amt -- 借据金额
    ,exec_int_rat -- 执行利率
    ,dubil_bal -- 借据余额
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,loan_usage_cd -- 贷款用途代码
    ,main_guar_way_cd -- 主担保方式代码
    ,indus_type_cd -- 行业类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_type_subdv_cd -- 贷款类型细分代码
    ,corp_size_cd -- 企业规模代码
    ,corp_number -- 企业人数
    ,last_year_bus_inco -- 上年末营业收入
    ,in_pool_flg -- 入池标志
    ,refac_status_cd -- 支小再状态代码
    ,cust_mgr_id -- 客户经理编号
    ,org_name -- 机构名称
    ,dubil_status_cd -- 借据状态代码
    ,batch_pkg_name -- 批次包名称
    ,dubil_invalid_dt -- 借据失效日期
    ,corp_asset_tot -- 企业资产总额(万元)
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_refac_dubil_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_refac_dubil_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_refac_dubil_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zxz_bill_info-
insert into ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,batch_pkg_id -- 批次包编号
    ,cert_name -- 证件名称
    ,cert_no -- 证件号码
    ,cust_type_cd -- 客户类型代码
    ,dubil_amt -- 借据金额
    ,exec_int_rat -- 执行利率
    ,dubil_bal -- 借据余额
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,loan_usage_cd -- 贷款用途代码
    ,main_guar_way_cd -- 主担保方式代码
    ,indus_type_cd -- 行业类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_type_subdv_cd -- 贷款类型细分代码
    ,corp_size_cd -- 企业规模代码
    ,corp_number -- 企业人数
    ,last_year_bus_inco -- 上年末营业收入
    ,in_pool_flg -- 入池标志
    ,refac_status_cd -- 支小再状态代码
    ,cust_mgr_id -- 客户经理编号
    ,org_name -- 机构名称
    ,dubil_status_cd -- 借据状态代码
    ,batch_pkg_name -- 批次包名称
    ,dubil_invalid_dt -- 借据失效日期
    ,corp_asset_tot -- 企业资产总额(万元)
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222302'||P1.BILLNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BILLNO -- 借据编号
    ,P1.PACKAGENO -- 批次包编号
    ,P1.CUSNAME -- 证件名称
    ,P1.CERTCODE -- 证件号码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BUSINESSESFLAG END -- 客户类型代码
    ,P1.LOANAMOUNT -- 借据金额
    ,P1.REALITYIRY*100 -- 执行利率
    ,P1.LOANBALANCE -- 借据余额
    ,${iml_schema}.dateformat_min(P1.LOANSTARTDATE) -- 贷款发放日期
    ,${iml_schema}.dateformat_max2(P1.LOANENDDATE) -- 贷款到期日期
    ,P1.CLA -- 贷款五级分类代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LOANUSETYPE end -- 贷款用途代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ASSUREMEANSMAIN END -- 主担保方式代码
    ,P1.INDIVCOMFLD -- 行业类型代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.COMPTYPE END -- 贷款类型代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.COMPTYPEDETAIL END -- 贷款类型细分代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.COMPSIZE END -- 企业规模代码
    ,P1.WORKERSNUM -- 企业人数
    ,P1.LASTYEARBUSSUM -- 上年末营业收入
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.INPOOLFLAG end -- 入池标志
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.ZXZFLAG END -- 支小再状态代码
    ,P1.CUSMANAGER -- 客户经理编号
    ,P1.MAINBRID -- 机构名称
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||P1.ACCOUNTSTATUS END -- 借据状态代码
    ,P1.PACKAGENAME -- 批次包名称
    ,${iml_schema}.dateformat_max2(P1.BILLENDDATE) -- 借据失效日期
    ,P1.TOTALASSETS -- 企业资产总额(万元)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zxz_bill_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zxz_bill_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUSINESSESFLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_ZXZ_BILL_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'BUSINESSESFLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LOANUSETYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_ZXZ_BILL_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'LOANUSETYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_ATTACH_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LOAN_USAGE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ASSUREMEANSMAIN = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_ZXZ_BILL_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'ASSUREMEANSMAIN'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_ATTACH_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'MAIN_GUAR_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.COMPTYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'ICMS_ZXZ_BILL_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'COMPTYPE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_ATTACH_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'LOAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.COMPTYPEDETAIL = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ICMS'
        AND R5.SRC_TAB_EN_NAME= 'ICMS_ZXZ_BILL_INFO'
        AND R5.SRC_FIELD_EN_NAME= 'COMPTYPEDETAIL'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_ATTACH_INFO_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'LOAN_TYPE_SUBDV_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.COMPSIZE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ICMS'
        AND R6.SRC_TAB_EN_NAME= 'ICMS_ZXZ_BILL_INFO'
        AND R6.SRC_FIELD_EN_NAME= 'COMPSIZE'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_ATTACH_INFO_H'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'CORP_SIZE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.INPOOLFLAG = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'ICMS'
        AND R8.SRC_TAB_EN_NAME= 'ICMS_ZXZ_BILL_INFO'
        AND R8.SRC_FIELD_EN_NAME= 'INPOOLFLAG'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_ATTACH_INFO_H'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'IN_POOL_FLG'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.ZXZFLAG = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'ICMS'
        AND R9.SRC_TAB_EN_NAME= 'ICMS_ZXZ_BILL_INFO'
        AND R9.SRC_FIELD_EN_NAME= 'ZXZFLAG'
        AND R9.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_ATTACH_INFO_H'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'REFAC_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.ACCOUNTSTATUS = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'ICMS'
        AND R10.SRC_TAB_EN_NAME= 'ICMS_ZXZ_BILL_INFO'
        AND R10.SRC_FIELD_EN_NAME= 'ACCOUNTSTATUS'
        AND R10.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_ATTACH_INFO_H'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'DUBIL_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,batch_pkg_id
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
        into ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,batch_pkg_id -- 批次包编号
    ,cert_name -- 证件名称
    ,cert_no -- 证件号码
    ,cust_type_cd -- 客户类型代码
    ,dubil_amt -- 借据金额
    ,exec_int_rat -- 执行利率
    ,dubil_bal -- 借据余额
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,loan_usage_cd -- 贷款用途代码
    ,main_guar_way_cd -- 主担保方式代码
    ,indus_type_cd -- 行业类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_type_subdv_cd -- 贷款类型细分代码
    ,corp_size_cd -- 企业规模代码
    ,corp_number -- 企业人数
    ,last_year_bus_inco -- 上年末营业收入
    ,in_pool_flg -- 入池标志
    ,refac_status_cd -- 支小再状态代码
    ,cust_mgr_id -- 客户经理编号
    ,org_name -- 机构名称
    ,dubil_status_cd -- 借据状态代码
    ,batch_pkg_name -- 批次包名称
    ,dubil_invalid_dt -- 借据失效日期
    ,corp_asset_tot -- 企业资产总额(万元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,batch_pkg_id -- 批次包编号
    ,cert_name -- 证件名称
    ,cert_no -- 证件号码
    ,cust_type_cd -- 客户类型代码
    ,dubil_amt -- 借据金额
    ,exec_int_rat -- 执行利率
    ,dubil_bal -- 借据余额
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,loan_usage_cd -- 贷款用途代码
    ,main_guar_way_cd -- 主担保方式代码
    ,indus_type_cd -- 行业类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_type_subdv_cd -- 贷款类型细分代码
    ,corp_size_cd -- 企业规模代码
    ,corp_number -- 企业人数
    ,last_year_bus_inco -- 上年末营业收入
    ,in_pool_flg -- 入池标志
    ,refac_status_cd -- 支小再状态代码
    ,cust_mgr_id -- 客户经理编号
    ,org_name -- 机构名称
    ,dubil_status_cd -- 借据状态代码
    ,batch_pkg_name -- 批次包名称
    ,dubil_invalid_dt -- 借据失效日期
    ,corp_asset_tot -- 企业资产总额(万元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.batch_pkg_id, o.batch_pkg_id) as batch_pkg_id -- 批次包编号
    ,nvl(n.cert_name, o.cert_name) as cert_name -- 证件名称
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.dubil_amt, o.dubil_amt) as dubil_amt -- 借据金额
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.dubil_bal, o.dubil_bal) as dubil_bal -- 借据余额
    ,nvl(n.loan_distr_dt, o.loan_distr_dt) as loan_distr_dt -- 贷款发放日期
    ,nvl(n.loan_exp_dt, o.loan_exp_dt) as loan_exp_dt -- 贷款到期日期
    ,nvl(n.loan_level5_cls_cd, o.loan_level5_cls_cd) as loan_level5_cls_cd -- 贷款五级分类代码
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.loan_type_subdv_cd, o.loan_type_subdv_cd) as loan_type_subdv_cd -- 贷款类型细分代码
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.corp_number, o.corp_number) as corp_number -- 企业人数
    ,nvl(n.last_year_bus_inco, o.last_year_bus_inco) as last_year_bus_inco -- 上年末营业收入
    ,nvl(n.in_pool_flg, o.in_pool_flg) as in_pool_flg -- 入池标志
    ,nvl(n.refac_status_cd, o.refac_status_cd) as refac_status_cd -- 支小再状态代码
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名称
    ,nvl(n.dubil_status_cd, o.dubil_status_cd) as dubil_status_cd -- 借据状态代码
    ,nvl(n.batch_pkg_name, o.batch_pkg_name) as batch_pkg_name -- 批次包名称
    ,nvl(n.dubil_invalid_dt, o.dubil_invalid_dt) as dubil_invalid_dt -- 借据失效日期
    ,nvl(n.corp_asset_tot, o.corp_asset_tot) as corp_asset_tot -- 企业资产总额(万元)
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.batch_pkg_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.batch_pkg_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.batch_pkg_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.batch_pkg_id = n.batch_pkg_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.batch_pkg_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.batch_pkg_id is null
    )
    or (
        o.dubil_id <> n.dubil_id
        or o.cert_name <> n.cert_name
        or o.cert_no <> n.cert_no
        or o.cust_type_cd <> n.cust_type_cd
        or o.dubil_amt <> n.dubil_amt
        or o.exec_int_rat <> n.exec_int_rat
        or o.dubil_bal <> n.dubil_bal
        or o.loan_distr_dt <> n.loan_distr_dt
        or o.loan_exp_dt <> n.loan_exp_dt
        or o.loan_level5_cls_cd <> n.loan_level5_cls_cd
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.indus_type_cd <> n.indus_type_cd
        or o.loan_type_cd <> n.loan_type_cd
        or o.loan_type_subdv_cd <> n.loan_type_subdv_cd
        or o.corp_size_cd <> n.corp_size_cd
        or o.corp_number <> n.corp_number
        or o.last_year_bus_inco <> n.last_year_bus_inco
        or o.in_pool_flg <> n.in_pool_flg
        or o.refac_status_cd <> n.refac_status_cd
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.org_name <> n.org_name
        or o.dubil_status_cd <> n.dubil_status_cd
        or o.batch_pkg_name <> n.batch_pkg_name
        or o.dubil_invalid_dt <> n.dubil_invalid_dt
        or o.corp_asset_tot <> n.corp_asset_tot
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,batch_pkg_id -- 批次包编号
    ,cert_name -- 证件名称
    ,cert_no -- 证件号码
    ,cust_type_cd -- 客户类型代码
    ,dubil_amt -- 借据金额
    ,exec_int_rat -- 执行利率
    ,dubil_bal -- 借据余额
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,loan_usage_cd -- 贷款用途代码
    ,main_guar_way_cd -- 主担保方式代码
    ,indus_type_cd -- 行业类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_type_subdv_cd -- 贷款类型细分代码
    ,corp_size_cd -- 企业规模代码
    ,corp_number -- 企业人数
    ,last_year_bus_inco -- 上年末营业收入
    ,in_pool_flg -- 入池标志
    ,refac_status_cd -- 支小再状态代码
    ,cust_mgr_id -- 客户经理编号
    ,org_name -- 机构名称
    ,dubil_status_cd -- 借据状态代码
    ,batch_pkg_name -- 批次包名称
    ,dubil_invalid_dt -- 借据失效日期
    ,corp_asset_tot -- 企业资产总额(万元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,batch_pkg_id -- 批次包编号
    ,cert_name -- 证件名称
    ,cert_no -- 证件号码
    ,cust_type_cd -- 客户类型代码
    ,dubil_amt -- 借据金额
    ,exec_int_rat -- 执行利率
    ,dubil_bal -- 借据余额
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,loan_usage_cd -- 贷款用途代码
    ,main_guar_way_cd -- 主担保方式代码
    ,indus_type_cd -- 行业类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_type_subdv_cd -- 贷款类型细分代码
    ,corp_size_cd -- 企业规模代码
    ,corp_number -- 企业人数
    ,last_year_bus_inco -- 上年末营业收入
    ,in_pool_flg -- 入池标志
    ,refac_status_cd -- 支小再状态代码
    ,cust_mgr_id -- 客户经理编号
    ,org_name -- 机构名称
    ,dubil_status_cd -- 借据状态代码
    ,batch_pkg_name -- 批次包名称
    ,dubil_invalid_dt -- 借据失效日期
    ,corp_asset_tot -- 企业资产总额(万元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.dubil_id -- 借据编号
    ,o.batch_pkg_id -- 批次包编号
    ,o.cert_name -- 证件名称
    ,o.cert_no -- 证件号码
    ,o.cust_type_cd -- 客户类型代码
    ,o.dubil_amt -- 借据金额
    ,o.exec_int_rat -- 执行利率
    ,o.dubil_bal -- 借据余额
    ,o.loan_distr_dt -- 贷款发放日期
    ,o.loan_exp_dt -- 贷款到期日期
    ,o.loan_level5_cls_cd -- 贷款五级分类代码
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.indus_type_cd -- 行业类型代码
    ,o.loan_type_cd -- 贷款类型代码
    ,o.loan_type_subdv_cd -- 贷款类型细分代码
    ,o.corp_size_cd -- 企业规模代码
    ,o.corp_number -- 企业人数
    ,o.last_year_bus_inco -- 上年末营业收入
    ,o.in_pool_flg -- 入池标志
    ,o.refac_status_cd -- 支小再状态代码
    ,o.cust_mgr_id -- 客户经理编号
    ,o.org_name -- 机构名称
    ,o.dubil_status_cd -- 借据状态代码
    ,o.batch_pkg_name -- 批次包名称
    ,o.dubil_invalid_dt -- 借据失效日期
    ,o.corp_asset_tot -- 企业资产总额(万元)
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.batch_pkg_id = n.batch_pkg_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.batch_pkg_id = d.batch_pkg_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_refac_dubil_attach_info_h;
alter table ${iml_schema}.agt_refac_dubil_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_refac_dubil_attach_info_h exchange subpartition p_icmsf1_19000101 with table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_refac_dubil_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_refac_dubil_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_refac_dubil_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_refac_dubil_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
