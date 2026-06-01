/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_evt_core_basic_tran_addit
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_evt_core_basic_tran_addit drop partition p_${last_date};
alter table ${idl_schema}.aml_evt_core_basic_tran_addit drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_evt_core_basic_tran_addit add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_evt_core_basic_tran_addit (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,tran_flow_num  -- 交易流水号
    ,tran_dt  -- 交易日期
    ,agent_name  -- 代理人名称
    ,agent_cert_type_cd  -- 代理人证件类型代码
    ,agent_cert_no  -- 代理人证件号码
    ,agent_nation_cd  -- 代理人国籍代码
    ,agent_gender_cd  -- 代理人性别代码
    ,agent_cert_exp_dt  -- 代理人证件到期日
    ,agent_phone  -- 代理人联系电话
    ,agent_licen_issue_autho_site  -- 代理人发证机关所在地
    ,agent_type_cd  -- 代理类型代码
    ,agent_rs  -- 代理原因
    ,operr_cert_type_cd  -- 经办人证件类型代码
    ,operr_cert_no  -- 经办人证件号码
    ,operr_name  -- 经办人名称
    ,memo  -- 摘要
    ,comnt_remark_postsc  -- 说明备注附言
    ,ext_field_1  -- 扩展字段1
    ,ext_field_2  -- 扩展字段2
    ,ext_field_3  -- 扩展字段3
    ,ext_field_4  -- 扩展字段4
    ,ext_field_5  -- 扩展字段5
    ,ext_field_6  -- 扩展字段6
    ,ext_field_7  -- 扩展字段7
    ,ext_field_8  -- 扩展字段8
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,t1.tran_dt  -- 交易日期
    ,replace(replace(t1.agent_name,chr(13),''),chr(10),'')  -- 代理人名称
    ,replace(replace(t1.agent_cert_type_cd,chr(13),''),chr(10),'')  -- 代理人证件类型代码
    ,replace(replace(t1.agent_cert_no,chr(13),''),chr(10),'')  -- 代理人证件号码
    ,replace(replace(t1.agent_nation_cd,chr(13),''),chr(10),'')  -- 代理人国籍代码
    ,replace(replace(t1.agent_gender_cd,chr(13),''),chr(10),'')  -- 代理人性别代码
    ,t1.agent_cert_exp_dt  -- 代理人证件到期日
    ,replace(replace(t1.agent_phone,chr(13),''),chr(10),'')  -- 代理人联系电话
    ,replace(replace(t1.agent_licen_issue_autho_site,chr(13),''),chr(10),'')  -- 代理人发证机关所在地
    ,replace(replace(t1.agent_type_cd,chr(13),''),chr(10),'')  -- 代理类型代码
    ,replace(replace(t1.agent_rs,chr(13),''),chr(10),'')  -- 代理原因
    ,replace(replace(t1.operr_cert_type_cd,chr(13),''),chr(10),'')  -- 经办人证件类型代码
    ,replace(replace(t1.operr_cert_no,chr(13),''),chr(10),'')  -- 经办人证件号码
    ,replace(replace(t1.operr_name,chr(13),''),chr(10),'')  -- 经办人名称
    ,replace(replace(t1.memo,chr(13),''),chr(10),'')  -- 摘要
    ,replace(replace(t1.comnt_remark_postsc,chr(13),''),chr(10),'')  -- 说明备注附言
    ,replace(replace(t1.ext_field_1,chr(13),''),chr(10),'')  -- 扩展字段1
    ,replace(replace(t1.ext_field_2,chr(13),''),chr(10),'')  -- 扩展字段2
    ,replace(replace(t1.ext_field_3,chr(13),''),chr(10),'')  -- 扩展字段3
    ,replace(replace(t1.ext_field_4,chr(13),''),chr(10),'')  -- 扩展字段4
    ,replace(replace(t1.ext_field_5,chr(13),''),chr(10),'')  -- 扩展字段5
    ,replace(replace(t1.ext_field_6,chr(13),''),chr(10),'')  -- 扩展字段6
    ,replace(replace(t1.ext_field_7,chr(13),''),chr(10),'')  -- 扩展字段7
    ,replace(replace(t1.ext_field_8,chr(13),''),chr(10),'')  -- 扩展字段8
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.evt_core_basic_tran_addit t1    --核心基本交易附加表
where t1.tran_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_evt_core_basic_tran_addit',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);