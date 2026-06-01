/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_salary_plat_payoff_corp_info_mpcsf1
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
alter table ${iml_schema}.pty_salary_plat_payoff_corp_info add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_salary_plat_payoff_corp_info partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_tm purge;
drop table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_op purge;
drop table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_abbr -- 企业简称
    ,corp_size_cd -- 企业规模代码
    ,indus_type_cd -- 行业类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,local_prov -- 所在省
    ,local_city -- 所在市
    ,local_rg -- 所在区
    ,dtl_addr -- 详细地址
    ,imp_cust_flg -- 重点客户标志
    ,cust_type_cd -- 客户类型代码
    ,bank_org_id -- 银行机构编号
    ,bank_mgmt_id -- 银行管理员工编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,corp_hibchy -- 企业层级
    ,super_corp_id -- 上级企业编号
    ,lp_name -- 法人名称
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,chc_cert_type_cd -- 认证类型代码
    ,cert_submit_dt -- 认证提交日期
    ,start_use_flg -- 启用标志
    ,cert_submit_emply_id -- 认证提交员工编号
    ,fir_cert_sucs_dt -- 首次认证成功日期
    ,corp_cert_status_cd -- 企业认证状态代码
    ,cert_fail_rs -- 认证失败原因
    ,corp_dsmis_status_cd -- 企业解散状态代码
    ,corp_dsmis_flow_num -- 企业解散流水号
    ,allow_emply_srch_reach_corp_flg -- 允许员工搜索到企业标志
    ,allow_other_corp_rela_flg -- 允许其他企业关联标志
    ,batch_no -- 批次号
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_salary_plat_payoff_corp_info partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_salary_plat_payoff_corp_info partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_salary_plat_payoff_corp_info partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a1wcm_company_info-1
insert into ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_abbr -- 企业简称
    ,corp_size_cd -- 企业规模代码
    ,indus_type_cd -- 行业类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,local_prov -- 所在省
    ,local_city -- 所在市
    ,local_rg -- 所在区
    ,dtl_addr -- 详细地址
    ,imp_cust_flg -- 重点客户标志
    ,cust_type_cd -- 客户类型代码
    ,bank_org_id -- 银行机构编号
    ,bank_mgmt_id -- 银行管理员工编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,corp_hibchy -- 企业层级
    ,super_corp_id -- 上级企业编号
    ,lp_name -- 法人名称
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,chc_cert_type_cd -- 认证类型代码
    ,cert_submit_dt -- 认证提交日期
    ,start_use_flg -- 启用标志
    ,cert_submit_emply_id -- 认证提交员工编号
    ,fir_cert_sucs_dt -- 首次认证成功日期
    ,corp_cert_status_cd -- 企业认证状态代码
    ,cert_fail_rs -- 认证失败原因
    ,corp_dsmis_status_cd -- 企业解散状态代码
    ,corp_dsmis_flow_num -- 企业解散流水号
    ,allow_emply_srch_reach_corp_flg -- 允许员工搜索到企业标志
    ,allow_other_corp_rela_flg -- 允许其他企业关联标志
    ,batch_no -- 批次号
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '901003'||P1.COMPANY_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.COMPANY_ID -- 企业编号
    ,P1.COMPANY_NAME -- 企业名称
    ,P1.COMPANY_SHORT_NAME -- 企业简称
    ,nvl(trim(P1.COMPANY_SCALE),'-') -- 企业规模代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL  ELSE '@'||P1.COMPANY_SECTOR_TYPE END -- 行业类型代码
    ,nvl(trim(P1.BUSINESS_LICENSE_TYPE),'0000') -- 证件类型代码
    ,P1.BUSINESS_LICENSE_NO -- 证件号码
    ,P1.COMPANY_PROVINCE -- 所在省
    ,P1.COMPANY_CITY -- 所在市
    ,P1.COMPANY_REGION -- 所在区
    ,P1.COMPANY_ADDRESS -- 详细地址
    ,decode(P1.KEY_CUSTOMER_FLAG,'Y','1','N','0',' ','-',P1.KEY_CUSTOMER_FLAG) -- 重点客户标志
    ,nvl(trim(P1.CUSTOMER_TYPE),'06') -- 客户类型代码
    ,P1.BANK_BRANCH_NO -- 银行机构编号
    ,P1.SUPER_ADMIN_EMPLOYEE_ID -- 银行管理员工编号
    ,P1.BANK_CUSTOMER_MANAGER_ID -- 银行客户经理编号
    ,P1.COMPANY_LEVEL_TYPE -- 企业层级
    ,P1.PARENT_COMPANY_ID -- 上级企业编号
    ,P1.LEGAL_NAME -- 法人名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL     
     ELSE '@'||P1.LEGAL_CERT_TYPE 
END -- 法人证件类型代码
    ,P1.LEGAL_CERT_NO -- 法人证件号码
    ,nvl(trim(P1.AUTH_TYPE),'-') -- 认证类型代码
    ,${iml_schema}.dateformat_min(P1.AUTH_SUBMIT_TIMESTAMP) -- 认证提交日期
    ,nvl(trim(P1.ENABLE_STATUS),'-') -- 启用标志
    ,P1.AUTH_SUBMIT_EMPLOYEE_ID -- 认证提交员工编号
    ,${iml_schema}.dateformat_min(P1.AUTH_FIRST_SUCC_TIMESTAMP) -- 首次认证成功日期
    ,nvl(trim(P1.COMPANY_AUTH_STATUS),'-') -- 企业认证状态代码
    ,P1.AUTH_FAIL_REASON -- 认证失败原因
    ,nvl(trim(P1.COMPANY_DISSOLVE_STATUS),'-') -- 企业解散状态代码
    ,P1.SYS_SERIAL_NO -- 企业解散流水号
    ,decode(P1.ALLOW_EMPLOYEE_SEARCH_FLAG,'Y','1','N','0',' ','-',P1.ALLOW_EMPLOYEE_SEARCH_FLAG) -- 允许员工搜索到企业标志
    ,decode(P1.ALLOW_COMPANY_ASSOCIATION_FLAG,'Y','1','N','0',' ','-',P1.ALLOW_COMPANY_ASSOCIATION_FLAG) -- 允许其他企业关联标志
    ,P1.BATCH_ID -- 批次号
    ,${iml_schema}.dateformat_min(P1.CREATE_TIMESTAMP) -- 批次创建日期
    ,${iml_schema}.dateformat_max2(P1.UPDATE_TIMESTAMP) -- 批次更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a1wcm_company_info' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1wcm_company_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.COMPANY_SECTOR_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A1WCM_COMPANY_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'COMPANY_SECTOR_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_SALARY_PLAT_PAYOFF_CORP_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INDUS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LEGAL_CERT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A1WCM_COMPANY_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'LEGAL_CERT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_SALARY_PLAT_PAYOFF_CORP_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LP_CERT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_tm 
  	                                group by 
  	                                        party_id
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
        into ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_abbr -- 企业简称
    ,corp_size_cd -- 企业规模代码
    ,indus_type_cd -- 行业类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,local_prov -- 所在省
    ,local_city -- 所在市
    ,local_rg -- 所在区
    ,dtl_addr -- 详细地址
    ,imp_cust_flg -- 重点客户标志
    ,cust_type_cd -- 客户类型代码
    ,bank_org_id -- 银行机构编号
    ,bank_mgmt_id -- 银行管理员工编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,corp_hibchy -- 企业层级
    ,super_corp_id -- 上级企业编号
    ,lp_name -- 法人名称
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,chc_cert_type_cd -- 认证类型代码
    ,cert_submit_dt -- 认证提交日期
    ,start_use_flg -- 启用标志
    ,cert_submit_emply_id -- 认证提交员工编号
    ,fir_cert_sucs_dt -- 首次认证成功日期
    ,corp_cert_status_cd -- 企业认证状态代码
    ,cert_fail_rs -- 认证失败原因
    ,corp_dsmis_status_cd -- 企业解散状态代码
    ,corp_dsmis_flow_num -- 企业解散流水号
    ,allow_emply_srch_reach_corp_flg -- 允许员工搜索到企业标志
    ,allow_other_corp_rela_flg -- 允许其他企业关联标志
    ,batch_no -- 批次号
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_abbr -- 企业简称
    ,corp_size_cd -- 企业规模代码
    ,indus_type_cd -- 行业类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,local_prov -- 所在省
    ,local_city -- 所在市
    ,local_rg -- 所在区
    ,dtl_addr -- 详细地址
    ,imp_cust_flg -- 重点客户标志
    ,cust_type_cd -- 客户类型代码
    ,bank_org_id -- 银行机构编号
    ,bank_mgmt_id -- 银行管理员工编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,corp_hibchy -- 企业层级
    ,super_corp_id -- 上级企业编号
    ,lp_name -- 法人名称
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,chc_cert_type_cd -- 认证类型代码
    ,cert_submit_dt -- 认证提交日期
    ,start_use_flg -- 启用标志
    ,cert_submit_emply_id -- 认证提交员工编号
    ,fir_cert_sucs_dt -- 首次认证成功日期
    ,corp_cert_status_cd -- 企业认证状态代码
    ,cert_fail_rs -- 认证失败原因
    ,corp_dsmis_status_cd -- 企业解散状态代码
    ,corp_dsmis_flow_num -- 企业解散流水号
    ,allow_emply_srch_reach_corp_flg -- 允许员工搜索到企业标志
    ,allow_other_corp_rela_flg -- 允许其他企业关联标志
    ,batch_no -- 批次号
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.corp_id, o.corp_id) as corp_id -- 企业编号
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 企业名称
    ,nvl(n.corp_abbr, o.corp_abbr) as corp_abbr -- 企业简称
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.local_prov, o.local_prov) as local_prov -- 所在省
    ,nvl(n.local_city, o.local_city) as local_city -- 所在市
    ,nvl(n.local_rg, o.local_rg) as local_rg -- 所在区
    ,nvl(n.dtl_addr, o.dtl_addr) as dtl_addr -- 详细地址
    ,nvl(n.imp_cust_flg, o.imp_cust_flg) as imp_cust_flg -- 重点客户标志
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.bank_org_id, o.bank_org_id) as bank_org_id -- 银行机构编号
    ,nvl(n.bank_mgmt_id, o.bank_mgmt_id) as bank_mgmt_id -- 银行管理员工编号
    ,nvl(n.bank_cust_mgr_id, o.bank_cust_mgr_id) as bank_cust_mgr_id -- 银行客户经理编号
    ,nvl(n.corp_hibchy, o.corp_hibchy) as corp_hibchy -- 企业层级
    ,nvl(n.super_corp_id, o.super_corp_id) as super_corp_id -- 上级企业编号
    ,nvl(n.lp_name, o.lp_name) as lp_name -- 法人名称
    ,nvl(n.lp_cert_type_cd, o.lp_cert_type_cd) as lp_cert_type_cd -- 法人证件类型代码
    ,nvl(n.lp_cert_no, o.lp_cert_no) as lp_cert_no -- 法人证件号码
    ,nvl(n.chc_cert_type_cd, o.chc_cert_type_cd) as chc_cert_type_cd -- 认证类型代码
    ,nvl(n.cert_submit_dt, o.cert_submit_dt) as cert_submit_dt -- 认证提交日期
    ,nvl(n.start_use_flg, o.start_use_flg) as start_use_flg -- 启用标志
    ,nvl(n.cert_submit_emply_id, o.cert_submit_emply_id) as cert_submit_emply_id -- 认证提交员工编号
    ,nvl(n.fir_cert_sucs_dt, o.fir_cert_sucs_dt) as fir_cert_sucs_dt -- 首次认证成功日期
    ,nvl(n.corp_cert_status_cd, o.corp_cert_status_cd) as corp_cert_status_cd -- 企业认证状态代码
    ,nvl(n.cert_fail_rs, o.cert_fail_rs) as cert_fail_rs -- 认证失败原因
    ,nvl(n.corp_dsmis_status_cd, o.corp_dsmis_status_cd) as corp_dsmis_status_cd -- 企业解散状态代码
    ,nvl(n.corp_dsmis_flow_num, o.corp_dsmis_flow_num) as corp_dsmis_flow_num -- 企业解散流水号
    ,nvl(n.allow_emply_srch_reach_corp_flg, o.allow_emply_srch_reach_corp_flg) as allow_emply_srch_reach_corp_flg -- 允许员工搜索到企业标志
    ,nvl(n.allow_other_corp_rela_flg, o.allow_other_corp_rela_flg) as allow_other_corp_rela_flg -- 允许其他企业关联标志
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.batch_create_dt, o.batch_create_dt) as batch_create_dt -- 批次创建日期
    ,nvl(n.batch_update_dt, o.batch_update_dt) as batch_update_dt -- 批次更新日期
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_tm n
    full join (select * from ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.corp_id <> n.corp_id
        or o.corp_name <> n.corp_name
        or o.corp_abbr <> n.corp_abbr
        or o.corp_size_cd <> n.corp_size_cd
        or o.indus_type_cd <> n.indus_type_cd
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.local_prov <> n.local_prov
        or o.local_city <> n.local_city
        or o.local_rg <> n.local_rg
        or o.dtl_addr <> n.dtl_addr
        or o.imp_cust_flg <> n.imp_cust_flg
        or o.cust_type_cd <> n.cust_type_cd
        or o.bank_org_id <> n.bank_org_id
        or o.bank_mgmt_id <> n.bank_mgmt_id
        or o.bank_cust_mgr_id <> n.bank_cust_mgr_id
        or o.corp_hibchy <> n.corp_hibchy
        or o.super_corp_id <> n.super_corp_id
        or o.lp_name <> n.lp_name
        or o.lp_cert_type_cd <> n.lp_cert_type_cd
        or o.lp_cert_no <> n.lp_cert_no
        or o.chc_cert_type_cd <> n.chc_cert_type_cd
        or o.cert_submit_dt <> n.cert_submit_dt
        or o.start_use_flg <> n.start_use_flg
        or o.cert_submit_emply_id <> n.cert_submit_emply_id
        or o.fir_cert_sucs_dt <> n.fir_cert_sucs_dt
        or o.corp_cert_status_cd <> n.corp_cert_status_cd
        or o.cert_fail_rs <> n.cert_fail_rs
        or o.corp_dsmis_status_cd <> n.corp_dsmis_status_cd
        or o.corp_dsmis_flow_num <> n.corp_dsmis_flow_num
        or o.allow_emply_srch_reach_corp_flg <> n.allow_emply_srch_reach_corp_flg
        or o.allow_other_corp_rela_flg <> n.allow_other_corp_rela_flg
        or o.batch_no <> n.batch_no
        or o.batch_create_dt <> n.batch_create_dt
        or o.batch_update_dt <> n.batch_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_abbr -- 企业简称
    ,corp_size_cd -- 企业规模代码
    ,indus_type_cd -- 行业类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,local_prov -- 所在省
    ,local_city -- 所在市
    ,local_rg -- 所在区
    ,dtl_addr -- 详细地址
    ,imp_cust_flg -- 重点客户标志
    ,cust_type_cd -- 客户类型代码
    ,bank_org_id -- 银行机构编号
    ,bank_mgmt_id -- 银行管理员工编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,corp_hibchy -- 企业层级
    ,super_corp_id -- 上级企业编号
    ,lp_name -- 法人名称
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,chc_cert_type_cd -- 认证类型代码
    ,cert_submit_dt -- 认证提交日期
    ,start_use_flg -- 启用标志
    ,cert_submit_emply_id -- 认证提交员工编号
    ,fir_cert_sucs_dt -- 首次认证成功日期
    ,corp_cert_status_cd -- 企业认证状态代码
    ,cert_fail_rs -- 认证失败原因
    ,corp_dsmis_status_cd -- 企业解散状态代码
    ,corp_dsmis_flow_num -- 企业解散流水号
    ,allow_emply_srch_reach_corp_flg -- 允许员工搜索到企业标志
    ,allow_other_corp_rela_flg -- 允许其他企业关联标志
    ,batch_no -- 批次号
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,corp_abbr -- 企业简称
    ,corp_size_cd -- 企业规模代码
    ,indus_type_cd -- 行业类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,local_prov -- 所在省
    ,local_city -- 所在市
    ,local_rg -- 所在区
    ,dtl_addr -- 详细地址
    ,imp_cust_flg -- 重点客户标志
    ,cust_type_cd -- 客户类型代码
    ,bank_org_id -- 银行机构编号
    ,bank_mgmt_id -- 银行管理员工编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,corp_hibchy -- 企业层级
    ,super_corp_id -- 上级企业编号
    ,lp_name -- 法人名称
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,chc_cert_type_cd -- 认证类型代码
    ,cert_submit_dt -- 认证提交日期
    ,start_use_flg -- 启用标志
    ,cert_submit_emply_id -- 认证提交员工编号
    ,fir_cert_sucs_dt -- 首次认证成功日期
    ,corp_cert_status_cd -- 企业认证状态代码
    ,cert_fail_rs -- 认证失败原因
    ,corp_dsmis_status_cd -- 企业解散状态代码
    ,corp_dsmis_flow_num -- 企业解散流水号
    ,allow_emply_srch_reach_corp_flg -- 允许员工搜索到企业标志
    ,allow_other_corp_rela_flg -- 允许其他企业关联标志
    ,batch_no -- 批次号
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.corp_id -- 企业编号
    ,o.corp_name -- 企业名称
    ,o.corp_abbr -- 企业简称
    ,o.corp_size_cd -- 企业规模代码
    ,o.indus_type_cd -- 行业类型代码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.local_prov -- 所在省
    ,o.local_city -- 所在市
    ,o.local_rg -- 所在区
    ,o.dtl_addr -- 详细地址
    ,o.imp_cust_flg -- 重点客户标志
    ,o.cust_type_cd -- 客户类型代码
    ,o.bank_org_id -- 银行机构编号
    ,o.bank_mgmt_id -- 银行管理员工编号
    ,o.bank_cust_mgr_id -- 银行客户经理编号
    ,o.corp_hibchy -- 企业层级
    ,o.super_corp_id -- 上级企业编号
    ,o.lp_name -- 法人名称
    ,o.lp_cert_type_cd -- 法人证件类型代码
    ,o.lp_cert_no -- 法人证件号码
    ,o.chc_cert_type_cd -- 认证类型代码
    ,o.cert_submit_dt -- 认证提交日期
    ,o.start_use_flg -- 启用标志
    ,o.cert_submit_emply_id -- 认证提交员工编号
    ,o.fir_cert_sucs_dt -- 首次认证成功日期
    ,o.corp_cert_status_cd -- 企业认证状态代码
    ,o.cert_fail_rs -- 认证失败原因
    ,o.corp_dsmis_status_cd -- 企业解散状态代码
    ,o.corp_dsmis_flow_num -- 企业解散流水号
    ,o.allow_emply_srch_reach_corp_flg -- 允许员工搜索到企业标志
    ,o.allow_other_corp_rela_flg -- 允许其他企业关联标志
    ,o.batch_no -- 批次号
    ,o.batch_create_dt -- 批次创建日期
    ,o.batch_update_dt -- 批次更新日期
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
from ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_bk o
    left join ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_salary_plat_payoff_corp_info;
--alter table ${iml_schema}.pty_salary_plat_payoff_corp_info truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_salary_plat_payoff_corp_info') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_salary_plat_payoff_corp_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_salary_plat_payoff_corp_info modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_salary_plat_payoff_corp_info exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_cl;
alter table ${iml_schema}.pty_salary_plat_payoff_corp_info exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_salary_plat_payoff_corp_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_tm purge;
drop table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_op purge;
drop table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_salary_plat_payoff_corp_info_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_salary_plat_payoff_corp_info', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
