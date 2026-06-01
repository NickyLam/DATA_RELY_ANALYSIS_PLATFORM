/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_cust_risk_warn_rgst_h_icmsf1
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
alter table ${iml_schema}.pty_cust_risk_warn_rgst_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_risk_warn_rgst_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_op purge;
drop table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,rgst_dt -- 登记日期
    ,warn_proc_status_cd -- 预警处理状态代码
    ,effect_flg -- 生效标志
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,org_id -- 机构编号
    ,rela_flow_num -- 关联流水号
    ,warn_init_way_cd -- 预警发起方式代码
    ,warn_type_cd -- 警示类型代码
    ,bal -- 余额
    ,exp_not_cmplt_flg -- 过期未完成标志
    ,flow_status_cd -- 流程状态代码
    ,task_closing_dt -- 任务截止日期
    ,warn_info -- 预警信息
    ,warn_info_src_cd -- 预警信息来源代码
    ,exp_flg -- 过期标志
    ,end_flg -- 结束标志
    ,cmplt_dt -- 完成日期
    ,cust_mgr_invalid_rs_remark -- 客户经理失效原因备注
    ,risk_mgr_invalid_rs_remark -- 风险经理失效原因备注
    ,mger_offic_invalid_remark -- 总经理室失效原因备注
    ,cust_mgr_effect_remark -- 客户经理生效原因备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_risk_warn_rgst_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_risk_warn_rgst_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_risk_warn_rgst_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_alert_wastebook-
insert into ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_tm(
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,rgst_dt -- 登记日期
    ,warn_proc_status_cd -- 预警处理状态代码
    ,effect_flg -- 生效标志
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,org_id -- 机构编号
    ,rela_flow_num -- 关联流水号
    ,warn_init_way_cd -- 预警发起方式代码
    ,warn_type_cd -- 警示类型代码
    ,bal -- 余额
    ,exp_not_cmplt_flg -- 过期未完成标志
    ,flow_status_cd -- 流程状态代码
    ,task_closing_dt -- 任务截止日期
    ,warn_info -- 预警信息
    ,warn_info_src_cd -- 预警信息来源代码
    ,exp_flg -- 过期标志
    ,end_flg -- 结束标志
    ,cmplt_dt -- 完成日期
    ,cust_mgr_invalid_rs_remark -- 客户经理失效原因备注
    ,risk_mgr_invalid_rs_remark -- 风险经理失效原因备注
    ,mger_offic_invalid_remark -- 总经理室失效原因备注
    ,cust_mgr_effect_remark -- 客户经理生效原因备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SERIALNO -- 流水号
    , '9999' -- 法人编号
    ,P1.CUSTOMERID -- 当事人编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.CUSTOMERTYPE),'-') -- 客户类型代码
    ,P1.INPUTDATE -- 登记日期
    ,P1.DELSTATUS -- 预警处理状态代码
    ,nvl(trim(P1.EFFECTFLAG),'-') -- 生效标志
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.CERTID -- 证件号码
    ,P1.ORGID -- 机构编号
    ,P1.RELATIVESERIALNO -- 关联流水号
    ,P1.BUILDTYPE -- 预警发起方式代码
    ,P1.ALERTTYPE -- 警示类型代码
    ,P1.BALANCE -- 余额
    ,nvl(trim(P1.ISOUTFINISH),'-') -- 过期未完成标志
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 流程状态代码
    ,P1.CUTDATE -- 任务截止日期
    ,P1.ALERTCONTENT -- 预警信息
    ,nvl(trim(P1.ALERTINFOSOURCE),'-') -- 预警信息来源代码
    ,nvl(trim(P1.ISOVERDUE),'-') -- 过期标志
    ,nvl(trim(P1.ENDSTATUS),'-') -- 结束标志
    ,P1.FINISHDATE -- 完成日期
    ,P1.REMARK1 -- 客户经理失效原因备注
    ,P1.REMARK2 -- 风险经理失效原因备注
    ,P1.REMARK3 -- 总经理室失效原因备注
    ,P1.REMARK4 -- 客户经理生效原因备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_alert_wastebook' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_alert_wastebook p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_tm 
  	                                group by 
  	                                        flow_num
  	                                        ,lp_id
  	                                        ,party_id
  	                                        ,cust_id
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
        into ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_cl(
            flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,rgst_dt -- 登记日期
    ,warn_proc_status_cd -- 预警处理状态代码
    ,effect_flg -- 生效标志
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,org_id -- 机构编号
    ,rela_flow_num -- 关联流水号
    ,warn_init_way_cd -- 预警发起方式代码
    ,warn_type_cd -- 警示类型代码
    ,bal -- 余额
    ,exp_not_cmplt_flg -- 过期未完成标志
    ,flow_status_cd -- 流程状态代码
    ,task_closing_dt -- 任务截止日期
    ,warn_info -- 预警信息
    ,warn_info_src_cd -- 预警信息来源代码
    ,exp_flg -- 过期标志
    ,end_flg -- 结束标志
    ,cmplt_dt -- 完成日期
    ,cust_mgr_invalid_rs_remark -- 客户经理失效原因备注
    ,risk_mgr_invalid_rs_remark -- 风险经理失效原因备注
    ,mger_offic_invalid_remark -- 总经理室失效原因备注
    ,cust_mgr_effect_remark -- 客户经理生效原因备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_op(
            flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,rgst_dt -- 登记日期
    ,warn_proc_status_cd -- 预警处理状态代码
    ,effect_flg -- 生效标志
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,org_id -- 机构编号
    ,rela_flow_num -- 关联流水号
    ,warn_init_way_cd -- 预警发起方式代码
    ,warn_type_cd -- 警示类型代码
    ,bal -- 余额
    ,exp_not_cmplt_flg -- 过期未完成标志
    ,flow_status_cd -- 流程状态代码
    ,task_closing_dt -- 任务截止日期
    ,warn_info -- 预警信息
    ,warn_info_src_cd -- 预警信息来源代码
    ,exp_flg -- 过期标志
    ,end_flg -- 结束标志
    ,cmplt_dt -- 完成日期
    ,cust_mgr_invalid_rs_remark -- 客户经理失效原因备注
    ,risk_mgr_invalid_rs_remark -- 风险经理失效原因备注
    ,mger_offic_invalid_remark -- 总经理室失效原因备注
    ,cust_mgr_effect_remark -- 客户经理生效原因备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.warn_proc_status_cd, o.warn_proc_status_cd) as warn_proc_status_cd -- 预警处理状态代码
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.rela_flow_num, o.rela_flow_num) as rela_flow_num -- 关联流水号
    ,nvl(n.warn_init_way_cd, o.warn_init_way_cd) as warn_init_way_cd -- 预警发起方式代码
    ,nvl(n.warn_type_cd, o.warn_type_cd) as warn_type_cd -- 警示类型代码
    ,nvl(n.bal, o.bal) as bal -- 余额
    ,nvl(n.exp_not_cmplt_flg, o.exp_not_cmplt_flg) as exp_not_cmplt_flg -- 过期未完成标志
    ,nvl(n.flow_status_cd, o.flow_status_cd) as flow_status_cd -- 流程状态代码
    ,nvl(n.task_closing_dt, o.task_closing_dt) as task_closing_dt -- 任务截止日期
    ,nvl(n.warn_info, o.warn_info) as warn_info -- 预警信息
    ,nvl(n.warn_info_src_cd, o.warn_info_src_cd) as warn_info_src_cd -- 预警信息来源代码
    ,nvl(n.exp_flg, o.exp_flg) as exp_flg -- 过期标志
    ,nvl(n.end_flg, o.end_flg) as end_flg -- 结束标志
    ,nvl(n.cmplt_dt, o.cmplt_dt) as cmplt_dt -- 完成日期
    ,nvl(n.cust_mgr_invalid_rs_remark, o.cust_mgr_invalid_rs_remark) as cust_mgr_invalid_rs_remark -- 客户经理失效原因备注
    ,nvl(n.risk_mgr_invalid_rs_remark, o.risk_mgr_invalid_rs_remark) as risk_mgr_invalid_rs_remark -- 风险经理失效原因备注
    ,nvl(n.mger_offic_invalid_remark, o.mger_offic_invalid_remark) as mger_offic_invalid_remark -- 总经理室失效原因备注
    ,nvl(n.cust_mgr_effect_remark, o.cust_mgr_effect_remark) as cust_mgr_effect_remark -- 客户经理生效原因备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.flow_num is null
            and n.lp_id is null
            and n.party_id is null
            and n.cust_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.flow_num is null
            and n.lp_id is null
            and n.party_id is null
            and n.cust_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.flow_num is null
            and n.lp_id is null
            and n.party_id is null
            and n.cust_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.flow_num = n.flow_num
            and o.lp_id = n.lp_id
            and o.party_id = n.party_id
            and o.cust_id = n.cust_id
where (
        o.flow_num is null
        and o.lp_id is null
        and o.party_id is null
        and o.cust_id is null
    )
    or (
        n.flow_num is null
        and n.lp_id is null
        and n.party_id is null
        and n.cust_id is null
    )
    or (
        o.cust_name <> n.cust_name
        or o.cust_type_cd <> n.cust_type_cd
        or o.rgst_dt <> n.rgst_dt
        or o.warn_proc_status_cd <> n.warn_proc_status_cd
        or o.effect_flg <> n.effect_flg
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.org_id <> n.org_id
        or o.rela_flow_num <> n.rela_flow_num
        or o.warn_init_way_cd <> n.warn_init_way_cd
        or o.warn_type_cd <> n.warn_type_cd
        or o.bal <> n.bal
        or o.exp_not_cmplt_flg <> n.exp_not_cmplt_flg
        or o.flow_status_cd <> n.flow_status_cd
        or o.task_closing_dt <> n.task_closing_dt
        or o.warn_info <> n.warn_info
        or o.warn_info_src_cd <> n.warn_info_src_cd
        or o.exp_flg <> n.exp_flg
        or o.end_flg <> n.end_flg
        or o.cmplt_dt <> n.cmplt_dt
        or o.cust_mgr_invalid_rs_remark <> n.cust_mgr_invalid_rs_remark
        or o.risk_mgr_invalid_rs_remark <> n.risk_mgr_invalid_rs_remark
        or o.mger_offic_invalid_remark <> n.mger_offic_invalid_remark
        or o.cust_mgr_effect_remark <> n.cust_mgr_effect_remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_cl(
            flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,rgst_dt -- 登记日期
    ,warn_proc_status_cd -- 预警处理状态代码
    ,effect_flg -- 生效标志
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,org_id -- 机构编号
    ,rela_flow_num -- 关联流水号
    ,warn_init_way_cd -- 预警发起方式代码
    ,warn_type_cd -- 警示类型代码
    ,bal -- 余额
    ,exp_not_cmplt_flg -- 过期未完成标志
    ,flow_status_cd -- 流程状态代码
    ,task_closing_dt -- 任务截止日期
    ,warn_info -- 预警信息
    ,warn_info_src_cd -- 预警信息来源代码
    ,exp_flg -- 过期标志
    ,end_flg -- 结束标志
    ,cmplt_dt -- 完成日期
    ,cust_mgr_invalid_rs_remark -- 客户经理失效原因备注
    ,risk_mgr_invalid_rs_remark -- 风险经理失效原因备注
    ,mger_offic_invalid_remark -- 总经理室失效原因备注
    ,cust_mgr_effect_remark -- 客户经理生效原因备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_op(
            flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,rgst_dt -- 登记日期
    ,warn_proc_status_cd -- 预警处理状态代码
    ,effect_flg -- 生效标志
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,org_id -- 机构编号
    ,rela_flow_num -- 关联流水号
    ,warn_init_way_cd -- 预警发起方式代码
    ,warn_type_cd -- 警示类型代码
    ,bal -- 余额
    ,exp_not_cmplt_flg -- 过期未完成标志
    ,flow_status_cd -- 流程状态代码
    ,task_closing_dt -- 任务截止日期
    ,warn_info -- 预警信息
    ,warn_info_src_cd -- 预警信息来源代码
    ,exp_flg -- 过期标志
    ,end_flg -- 结束标志
    ,cmplt_dt -- 完成日期
    ,cust_mgr_invalid_rs_remark -- 客户经理失效原因备注
    ,risk_mgr_invalid_rs_remark -- 风险经理失效原因备注
    ,mger_offic_invalid_remark -- 总经理室失效原因备注
    ,cust_mgr_effect_remark -- 客户经理生效原因备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.flow_num -- 流水号
    ,o.lp_id -- 法人编号
    ,o.party_id -- 当事人编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cust_type_cd -- 客户类型代码
    ,o.rgst_dt -- 登记日期
    ,o.warn_proc_status_cd -- 预警处理状态代码
    ,o.effect_flg -- 生效标志
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.org_id -- 机构编号
    ,o.rela_flow_num -- 关联流水号
    ,o.warn_init_way_cd -- 预警发起方式代码
    ,o.warn_type_cd -- 警示类型代码
    ,o.bal -- 余额
    ,o.exp_not_cmplt_flg -- 过期未完成标志
    ,o.flow_status_cd -- 流程状态代码
    ,o.task_closing_dt -- 任务截止日期
    ,o.warn_info -- 预警信息
    ,o.warn_info_src_cd -- 预警信息来源代码
    ,o.exp_flg -- 过期标志
    ,o.end_flg -- 结束标志
    ,o.cmplt_dt -- 完成日期
    ,o.cust_mgr_invalid_rs_remark -- 客户经理失效原因备注
    ,o.risk_mgr_invalid_rs_remark -- 风险经理失效原因备注
    ,o.mger_offic_invalid_remark -- 总经理室失效原因备注
    ,o.cust_mgr_effect_remark -- 客户经理生效原因备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_bk o
    left join ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_op n
        on
            o.flow_num = n.flow_num
            and o.lp_id = n.lp_id
            and o.party_id = n.party_id
            and o.cust_id = n.cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_cl d
        on
            o.flow_num = d.flow_num
            and o.lp_id = d.lp_id
            and o.party_id = d.party_id
            and o.cust_id = d.cust_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_cust_risk_warn_rgst_h;
--alter table ${iml_schema}.pty_cust_risk_warn_rgst_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_cust_risk_warn_rgst_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_cust_risk_warn_rgst_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_cust_risk_warn_rgst_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_cust_risk_warn_rgst_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_cl;
alter table ${iml_schema}.pty_cust_risk_warn_rgst_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_cust_risk_warn_rgst_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_op purge;
drop table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_cust_risk_warn_rgst_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_cust_risk_warn_rgst_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
