/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_jh_mercht_info_mrmsf1
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
alter table ${iml_schema}.pty_jh_mercht_info add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_jh_mercht_info_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_jh_mercht_info partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_jh_mercht_info_mrmsf1_tm purge;
drop table ${iml_schema}.pty_jh_mercht_info_mrmsf1_op purge;
drop table ${iml_schema}.pty_jh_mercht_info_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_jh_mercht_info_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,mercht_cn_name -- 商户中文名称
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_sign_dt -- 商户签约日期
    ,mercht_revo_dt -- 商户撤销日期
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_invalid_dt -- 证件失效日期
    ,mercht_tel_num -- 商户电话号码
    ,elec_addr -- 电子地址
    ,cotas_name -- 联系人名称
    ,cotas_type_cd -- 联系人类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,cotas_addr -- 联系人地址
    ,lp_name -- 法人名称
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,check_status_cd -- 审核状态代码
    ,risk_lev_cd -- 风险级别代码
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,org_id -- 机构编号
    ,mercht_local_prov_cd -- 商户所在省代码
    ,mercht_local_prov_name -- 商户所在省名称
    ,mercht_local_city_cd -- 商户所在市代码
    ,mercht_local_city_name -- 商户所在市名称
    ,mercht_local_rg_cd -- 商户所在区代码
    ,mercht_local_rg_name -- 商户所在区名称
    ,flow_bank_apv_flow_num -- 流程银行审批流水号
    ,flow_bank_apv_rest_cd -- 流程银行审批结果代码
    ,h5_flow_flg -- H5进件标志
    ,risk_mgmt_admit_status_cd -- 风控准入状态代码
    ,risk_mgmt_froz_cd -- 风控冻结代码
    ,risk_mgmt_descb -- 风控描述
    ,ext_mercht_id -- 外部商户编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_jh_mercht_info partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.pty_jh_mercht_info_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_jh_mercht_info partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.pty_jh_mercht_info_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_jh_mercht_info partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_jh_mcht_inf-
insert into ${iml_schema}.pty_jh_mercht_info_mrmsf1_tm(
    mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,mercht_cn_name -- 商户中文名称
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_sign_dt -- 商户签约日期
    ,mercht_revo_dt -- 商户撤销日期
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_invalid_dt -- 证件失效日期
    ,mercht_tel_num -- 商户电话号码
    ,elec_addr -- 电子地址
    ,cotas_name -- 联系人名称
    ,cotas_type_cd -- 联系人类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,cotas_addr -- 联系人地址
    ,lp_name -- 法人名称
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,check_status_cd -- 审核状态代码
    ,risk_lev_cd -- 风险级别代码
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,org_id -- 机构编号
    ,mercht_local_prov_cd -- 商户所在省代码
    ,mercht_local_prov_name -- 商户所在省名称
    ,mercht_local_city_cd -- 商户所在市代码
    ,mercht_local_city_name -- 商户所在市名称
    ,mercht_local_rg_cd -- 商户所在区代码
    ,mercht_local_rg_name -- 商户所在区名称
    ,flow_bank_apv_flow_num -- 流程银行审批流水号
    ,flow_bank_apv_rest_cd -- 流程银行审批结果代码
    ,h5_flow_flg -- H5进件标志
    ,risk_mgmt_admit_status_cd -- 风控准入状态代码
    ,risk_mgmt_froz_cd -- 风控冻结代码
    ,risk_mgmt_descb -- 风控描述
    ,ext_mercht_id -- 外部商户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.MCHT_NO -- 商户编号
    ,'9999' -- 法人编号
    ,P1.AGENT_CD -- 代理商编号
    ,P1.MCHT_NM -- 商户中文名称
    ,P1.MCHT_CN_ABBR -- 商户中文简称
    ,${iml_schema}.dateformat_min(P1.PROL_DATE) -- 商户签约日期
    ,${iml_schema}.dateformat_max2(P1.CLOSE_DATE) -- 商户撤销日期
    ,nvl(trim(P1.LICENSE_TYPE),'0000')  -- 证件类型代码
    ,P1.LICENCE_NO -- 证件号码
    ,case when length(P1.LICENCE_END_DATE)=6 then  ${iml_schema}.DATEFORMAT_MAX('20'||P1.LICENCE_END_DATE) else ${iml_schema}.DATEFORMAT_MAX(P1.LICENCE_END_DATE) end -- 证件失效日期
    ,P1.COMM_MOBIL -- 商户电话号码
    ,P1.COMM_EMAIL -- 电子地址
    ,P1.CONTACT -- 联系人名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CONTACT_CLASS END -- 联系人类型代码
    ,P1.IDENTITY_NO -- 联系人证件号码
    ,P1.COMM_TEL -- 联系人电话号码
    ,P1.ADDR -- 联系人地址
    ,P1.MANAGER -- 法人名称
    ,P1.LEGAL_PERSON_ID_CARD -- 法人证件号码
    ,P1.MANAGER_TEL -- 法人联系电话
    ,P1.OPER_NO -- 客户经理编号
    ,P1.OPER_NM -- 客户经理姓名
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.MCHT_STATUS END -- 审核状态代码
    ,P1.RISL_LVL -- 风险级别代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE) -- 申请日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.ENABLE_DATE) -- 启用日期
    ,P1.ACQ_INST_ID -- 机构编号
    ,nvl(trim(regexp_substr(P1.PROVINCE_CODE, '[0-9]+')),' ') -- 商户所在省代码
    ,nvl(trim(regexp_substr(P1.PROVINCE_CODE, '[^0-9]+')),' ') -- 商户所在省名称
    ,nvl(trim(regexp_substr(P1.CITY_CODE, '[0-9]+')),' ') -- 商户所在市代码
    ,nvl(trim(regexp_substr(P1.CITY_CODE, '[^0-9]+')),' ') -- 商户所在市名称
    ,nvl(trim(regexp_substr(P1.DISTRICT_CODE, '[0-9]+')),' ') -- 商户所在区代码
    ,nvl(trim(regexp_substr(P1.DISTRICT_CODE, '[^0-9]+')),' ') -- 商户所在区名称
    ,P1.FLOW_BANK_NO -- 流程银行审批流水号
    ,NVL(TRIM(P1.FLOW_BANK_STATUS),'9') -- 流程银行审批结果代码
    ,NVL(TRIM(P1.H5_FLOW_FLAG),'-') -- H5进件标志
    ,NVL(TRIM(P1.RISK_STATU),'9') -- 风控准入状态代码
    ,NVL(TRIM(P1.RISK_FLAG),'00') -- 风控冻结代码
    ,P1.RISK_DESCRIBE -- 风控描述
    ,P1.OUT_MCHT_NO -- 外部商户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_jh_mcht_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_jh_mcht_inf p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CONTACT_CLASS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MRMS'
        AND R2.SRC_TAB_EN_NAME= 'MRMS_TBL_JH_MCHT_INF'
        AND R2.SRC_FIELD_EN_NAME= 'CONTACT_CLASS'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_JH_MERCHT_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'COTAS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.MCHT_STATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MRMS'
        AND R3.SRC_TAB_EN_NAME= 'MRMS_TBL_JH_MCHT_INF'
        AND R3.SRC_FIELD_EN_NAME= 'MCHT_STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'PTY_JH_MERCHT_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CHECK_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_jh_mercht_info_mrmsf1_tm 
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
        into ${iml_schema}.pty_jh_mercht_info_mrmsf1_cl(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,mercht_cn_name -- 商户中文名称
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_sign_dt -- 商户签约日期
    ,mercht_revo_dt -- 商户撤销日期
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_invalid_dt -- 证件失效日期
    ,mercht_tel_num -- 商户电话号码
    ,elec_addr -- 电子地址
    ,cotas_name -- 联系人名称
    ,cotas_type_cd -- 联系人类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,cotas_addr -- 联系人地址
    ,lp_name -- 法人名称
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,check_status_cd -- 审核状态代码
    ,risk_lev_cd -- 风险级别代码
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,org_id -- 机构编号
    ,mercht_local_prov_cd -- 商户所在省代码
    ,mercht_local_prov_name -- 商户所在省名称
    ,mercht_local_city_cd -- 商户所在市代码
    ,mercht_local_city_name -- 商户所在市名称
    ,mercht_local_rg_cd -- 商户所在区代码
    ,mercht_local_rg_name -- 商户所在区名称
    ,flow_bank_apv_flow_num -- 流程银行审批流水号
    ,flow_bank_apv_rest_cd -- 流程银行审批结果代码
    ,h5_flow_flg -- H5进件标志
    ,risk_mgmt_admit_status_cd -- 风控准入状态代码
    ,risk_mgmt_froz_cd -- 风控冻结代码
    ,risk_mgmt_descb -- 风控描述
    ,ext_mercht_id -- 外部商户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_jh_mercht_info_mrmsf1_op(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,mercht_cn_name -- 商户中文名称
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_sign_dt -- 商户签约日期
    ,mercht_revo_dt -- 商户撤销日期
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_invalid_dt -- 证件失效日期
    ,mercht_tel_num -- 商户电话号码
    ,elec_addr -- 电子地址
    ,cotas_name -- 联系人名称
    ,cotas_type_cd -- 联系人类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,cotas_addr -- 联系人地址
    ,lp_name -- 法人名称
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,check_status_cd -- 审核状态代码
    ,risk_lev_cd -- 风险级别代码
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,org_id -- 机构编号
    ,mercht_local_prov_cd -- 商户所在省代码
    ,mercht_local_prov_name -- 商户所在省名称
    ,mercht_local_city_cd -- 商户所在市代码
    ,mercht_local_city_name -- 商户所在市名称
    ,mercht_local_rg_cd -- 商户所在区代码
    ,mercht_local_rg_name -- 商户所在区名称
    ,flow_bank_apv_flow_num -- 流程银行审批流水号
    ,flow_bank_apv_rest_cd -- 流程银行审批结果代码
    ,h5_flow_flg -- H5进件标志
    ,risk_mgmt_admit_status_cd -- 风控准入状态代码
    ,risk_mgmt_froz_cd -- 风控冻结代码
    ,risk_mgmt_descb -- 风控描述
    ,ext_mercht_id -- 外部商户编号
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
    ,nvl(n.agency_id, o.agency_id) as agency_id -- 代理商编号
    ,nvl(n.mercht_cn_name, o.mercht_cn_name) as mercht_cn_name -- 商户中文名称
    ,nvl(n.mercht_cn_abbr, o.mercht_cn_abbr) as mercht_cn_abbr -- 商户中文简称
    ,nvl(n.mercht_sign_dt, o.mercht_sign_dt) as mercht_sign_dt -- 商户签约日期
    ,nvl(n.mercht_revo_dt, o.mercht_revo_dt) as mercht_revo_dt -- 商户撤销日期
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_invalid_dt, o.cert_invalid_dt) as cert_invalid_dt -- 证件失效日期
    ,nvl(n.mercht_tel_num, o.mercht_tel_num) as mercht_tel_num -- 商户电话号码
    ,nvl(n.elec_addr, o.elec_addr) as elec_addr -- 电子地址
    ,nvl(n.cotas_name, o.cotas_name) as cotas_name -- 联系人名称
    ,nvl(n.cotas_type_cd, o.cotas_type_cd) as cotas_type_cd -- 联系人类型代码
    ,nvl(n.cotas_cert_no, o.cotas_cert_no) as cotas_cert_no -- 联系人证件号码
    ,nvl(n.cotas_tel_num, o.cotas_tel_num) as cotas_tel_num -- 联系人电话号码
    ,nvl(n.cotas_addr, o.cotas_addr) as cotas_addr -- 联系人地址
    ,nvl(n.lp_name, o.lp_name) as lp_name -- 法人名称
    ,nvl(n.lp_cert_no, o.lp_cert_no) as lp_cert_no -- 法人证件号码
    ,nvl(n.lp_phone, o.lp_phone) as lp_phone -- 法人联系电话
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.cust_mgr_name, o.cust_mgr_name) as cust_mgr_name -- 客户经理姓名
    ,nvl(n.check_status_cd, o.check_status_cd) as check_status_cd -- 审核状态代码
    ,nvl(n.risk_lev_cd, o.risk_lev_cd) as risk_lev_cd -- 风险级别代码
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.start_use_dt, o.start_use_dt) as start_use_dt -- 启用日期
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.mercht_local_prov_cd, o.mercht_local_prov_cd) as mercht_local_prov_cd -- 商户所在省代码
    ,nvl(n.mercht_local_prov_name, o.mercht_local_prov_name) as mercht_local_prov_name -- 商户所在省名称
    ,nvl(n.mercht_local_city_cd, o.mercht_local_city_cd) as mercht_local_city_cd -- 商户所在市代码
    ,nvl(n.mercht_local_city_name, o.mercht_local_city_name) as mercht_local_city_name -- 商户所在市名称
    ,nvl(n.mercht_local_rg_cd, o.mercht_local_rg_cd) as mercht_local_rg_cd -- 商户所在区代码
    ,nvl(n.mercht_local_rg_name, o.mercht_local_rg_name) as mercht_local_rg_name -- 商户所在区名称
    ,nvl(n.flow_bank_apv_flow_num, o.flow_bank_apv_flow_num) as flow_bank_apv_flow_num -- 流程银行审批流水号
    ,nvl(n.flow_bank_apv_rest_cd, o.flow_bank_apv_rest_cd) as flow_bank_apv_rest_cd -- 流程银行审批结果代码
    ,nvl(n.h5_flow_flg, o.h5_flow_flg) as h5_flow_flg -- H5进件标志
    ,nvl(n.risk_mgmt_admit_status_cd, o.risk_mgmt_admit_status_cd) as risk_mgmt_admit_status_cd -- 风控准入状态代码
    ,nvl(n.risk_mgmt_froz_cd, o.risk_mgmt_froz_cd) as risk_mgmt_froz_cd -- 风控冻结代码
    ,nvl(n.risk_mgmt_descb, o.risk_mgmt_descb) as risk_mgmt_descb -- 风控描述
    ,nvl(n.ext_mercht_id, o.ext_mercht_id) as ext_mercht_id -- 外部商户编号
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
from ${iml_schema}.pty_jh_mercht_info_mrmsf1_tm n
    full join (select * from ${iml_schema}.pty_jh_mercht_info_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.agency_id <> n.agency_id
        or o.mercht_cn_name <> n.mercht_cn_name
        or o.mercht_cn_abbr <> n.mercht_cn_abbr
        or o.mercht_sign_dt <> n.mercht_sign_dt
        or o.mercht_revo_dt <> n.mercht_revo_dt
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.cert_invalid_dt <> n.cert_invalid_dt
        or o.mercht_tel_num <> n.mercht_tel_num
        or o.elec_addr <> n.elec_addr
        or o.cotas_name <> n.cotas_name
        or o.cotas_type_cd <> n.cotas_type_cd
        or o.cotas_cert_no <> n.cotas_cert_no
        or o.cotas_tel_num <> n.cotas_tel_num
        or o.cotas_addr <> n.cotas_addr
        or o.lp_name <> n.lp_name
        or o.lp_cert_no <> n.lp_cert_no
        or o.lp_phone <> n.lp_phone
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.cust_mgr_name <> n.cust_mgr_name
        or o.check_status_cd <> n.check_status_cd
        or o.risk_lev_cd <> n.risk_lev_cd
        or o.appl_dt <> n.appl_dt
        or o.start_use_dt <> n.start_use_dt
        or o.org_id <> n.org_id
        or o.mercht_local_prov_cd <> n.mercht_local_prov_cd
        or o.mercht_local_prov_name <> n.mercht_local_prov_name
        or o.mercht_local_city_cd <> n.mercht_local_city_cd
        or o.mercht_local_city_name <> n.mercht_local_city_name
        or o.mercht_local_rg_cd <> n.mercht_local_rg_cd
        or o.mercht_local_rg_name <> n.mercht_local_rg_name
        or o.flow_bank_apv_flow_num <> n.flow_bank_apv_flow_num
        or o.flow_bank_apv_rest_cd <> n.flow_bank_apv_rest_cd
        or o.h5_flow_flg <> n.h5_flow_flg
        or o.risk_mgmt_admit_status_cd <> n.risk_mgmt_admit_status_cd
        or o.risk_mgmt_froz_cd <> n.risk_mgmt_froz_cd
        or o.risk_mgmt_descb <> n.risk_mgmt_descb
        or o.ext_mercht_id <> n.ext_mercht_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_jh_mercht_info_mrmsf1_cl(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,mercht_cn_name -- 商户中文名称
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_sign_dt -- 商户签约日期
    ,mercht_revo_dt -- 商户撤销日期
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_invalid_dt -- 证件失效日期
    ,mercht_tel_num -- 商户电话号码
    ,elec_addr -- 电子地址
    ,cotas_name -- 联系人名称
    ,cotas_type_cd -- 联系人类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,cotas_addr -- 联系人地址
    ,lp_name -- 法人名称
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,check_status_cd -- 审核状态代码
    ,risk_lev_cd -- 风险级别代码
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,org_id -- 机构编号
    ,mercht_local_prov_cd -- 商户所在省代码
    ,mercht_local_prov_name -- 商户所在省名称
    ,mercht_local_city_cd -- 商户所在市代码
    ,mercht_local_city_name -- 商户所在市名称
    ,mercht_local_rg_cd -- 商户所在区代码
    ,mercht_local_rg_name -- 商户所在区名称
    ,flow_bank_apv_flow_num -- 流程银行审批流水号
    ,flow_bank_apv_rest_cd -- 流程银行审批结果代码
    ,h5_flow_flg -- H5进件标志
    ,risk_mgmt_admit_status_cd -- 风控准入状态代码
    ,risk_mgmt_froz_cd -- 风控冻结代码
    ,risk_mgmt_descb -- 风控描述
    ,ext_mercht_id -- 外部商户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_jh_mercht_info_mrmsf1_op(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,agency_id -- 代理商编号
    ,mercht_cn_name -- 商户中文名称
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_sign_dt -- 商户签约日期
    ,mercht_revo_dt -- 商户撤销日期
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_invalid_dt -- 证件失效日期
    ,mercht_tel_num -- 商户电话号码
    ,elec_addr -- 电子地址
    ,cotas_name -- 联系人名称
    ,cotas_type_cd -- 联系人类型代码
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,cotas_addr -- 联系人地址
    ,lp_name -- 法人名称
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理姓名
    ,check_status_cd -- 审核状态代码
    ,risk_lev_cd -- 风险级别代码
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,org_id -- 机构编号
    ,mercht_local_prov_cd -- 商户所在省代码
    ,mercht_local_prov_name -- 商户所在省名称
    ,mercht_local_city_cd -- 商户所在市代码
    ,mercht_local_city_name -- 商户所在市名称
    ,mercht_local_rg_cd -- 商户所在区代码
    ,mercht_local_rg_name -- 商户所在区名称
    ,flow_bank_apv_flow_num -- 流程银行审批流水号
    ,flow_bank_apv_rest_cd -- 流程银行审批结果代码
    ,h5_flow_flg -- H5进件标志
    ,risk_mgmt_admit_status_cd -- 风控准入状态代码
    ,risk_mgmt_froz_cd -- 风控冻结代码
    ,risk_mgmt_descb -- 风控描述
    ,ext_mercht_id -- 外部商户编号
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
    ,o.agency_id -- 代理商编号
    ,o.mercht_cn_name -- 商户中文名称
    ,o.mercht_cn_abbr -- 商户中文简称
    ,o.mercht_sign_dt -- 商户签约日期
    ,o.mercht_revo_dt -- 商户撤销日期
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.cert_invalid_dt -- 证件失效日期
    ,o.mercht_tel_num -- 商户电话号码
    ,o.elec_addr -- 电子地址
    ,o.cotas_name -- 联系人名称
    ,o.cotas_type_cd -- 联系人类型代码
    ,o.cotas_cert_no -- 联系人证件号码
    ,o.cotas_tel_num -- 联系人电话号码
    ,o.cotas_addr -- 联系人地址
    ,o.lp_name -- 法人名称
    ,o.lp_cert_no -- 法人证件号码
    ,o.lp_phone -- 法人联系电话
    ,o.cust_mgr_id -- 客户经理编号
    ,o.cust_mgr_name -- 客户经理姓名
    ,o.check_status_cd -- 审核状态代码
    ,o.risk_lev_cd -- 风险级别代码
    ,o.appl_dt -- 申请日期
    ,o.start_use_dt -- 启用日期
    ,o.org_id -- 机构编号
    ,o.mercht_local_prov_cd -- 商户所在省代码
    ,o.mercht_local_prov_name -- 商户所在省名称
    ,o.mercht_local_city_cd -- 商户所在市代码
    ,o.mercht_local_city_name -- 商户所在市名称
    ,o.mercht_local_rg_cd -- 商户所在区代码
    ,o.mercht_local_rg_name -- 商户所在区名称
    ,o.flow_bank_apv_flow_num -- 流程银行审批流水号
    ,o.flow_bank_apv_rest_cd -- 流程银行审批结果代码
    ,o.h5_flow_flg -- H5进件标志
    ,o.risk_mgmt_admit_status_cd -- 风控准入状态代码
    ,o.risk_mgmt_froz_cd -- 风控冻结代码
    ,o.risk_mgmt_descb -- 风控描述
    ,o.ext_mercht_id -- 外部商户编号
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
from ${iml_schema}.pty_jh_mercht_info_mrmsf1_bk o
    left join ${iml_schema}.pty_jh_mercht_info_mrmsf1_op n
        on
            o.mercht_id = n.mercht_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_jh_mercht_info_mrmsf1_cl d
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
--truncate table ${iml_schema}.pty_jh_mercht_info;
--alter table ${iml_schema}.pty_jh_mercht_info truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_jh_mercht_info') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_jh_mercht_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_jh_mercht_info modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_jh_mercht_info exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.pty_jh_mercht_info_mrmsf1_cl;
alter table ${iml_schema}.pty_jh_mercht_info exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.pty_jh_mercht_info_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_jh_mercht_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_jh_mercht_info_mrmsf1_tm purge;
drop table ${iml_schema}.pty_jh_mercht_info_mrmsf1_op purge;
drop table ${iml_schema}.pty_jh_mercht_info_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_jh_mercht_info_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_jh_mercht_info', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
