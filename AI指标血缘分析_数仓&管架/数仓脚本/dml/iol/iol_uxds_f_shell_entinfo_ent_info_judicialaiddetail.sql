/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_shell_entinfo_ent_info_judicialaiddetail
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail_ex purge;
alter table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,cfrofrom -- 续行冻结期限自
    ,market_credit_code -- 被冻结股权所在市场统一社会信用代码
    ,ent_info_judicialaiddetail -- 关联标签
    ,id_type -- 证件类型
    ,cfroto -- 续行冻结期限至
    ,iname_type -- 被执行类型
    ,licence_type -- 被执行人类型
    ,shaream -- 股权数额
    ,expiration_reason -- 失效原因
    ,cur -- 币种
    ,publicdate -- 公示日期
    ,judgment_no -- 执行裁定书文号
    ,regist_no -- 被冻结股权所在市场主体注册号
    ,execution -- 执行事项
    ,freeze_flag -- 股权冻结状态
    ,fperiod -- 冻结期限
    ,freeze_date -- 解冻日期
    ,parent_id -- 被执行人ID
    ,expiration_date -- 失效日期
    ,frofrom -- 冻结期限自
    ,licence_no -- 证照编号
    ,ex_notice_no -- 协助执行通知书文号
    ,market_name -- 被冻结股权所在市场主体名称
    ,cfperiod -- 续行冻结期限
    ,iname -- 被执行人
    ,froto -- 冻结期限至
    ,courtname -- 执行法院
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,cfrofrom -- 续行冻结期限自
    ,market_credit_code -- 被冻结股权所在市场统一社会信用代码
    ,ent_info_judicialaiddetail -- 关联标签
    ,id_type -- 证件类型
    ,cfroto -- 续行冻结期限至
    ,iname_type -- 被执行类型
    ,licence_type -- 被执行人类型
    ,shaream -- 股权数额
    ,expiration_reason -- 失效原因
    ,cur -- 币种
    ,publicdate -- 公示日期
    ,judgment_no -- 执行裁定书文号
    ,regist_no -- 被冻结股权所在市场主体注册号
    ,execution -- 执行事项
    ,freeze_flag -- 股权冻结状态
    ,fperiod -- 冻结期限
    ,freeze_date -- 解冻日期
    ,parent_id -- 被执行人ID
    ,expiration_date -- 失效日期
    ,frofrom -- 冻结期限自
    ,licence_no -- 证照编号
    ,ex_notice_no -- 协助执行通知书文号
    ,market_name -- 被冻结股权所在市场主体名称
    ,cfperiod -- 续行冻结期限
    ,iname -- 被执行人
    ,froto -- 冻结期限至
    ,courtname -- 执行法院
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_shell_entinfo_ent_info_judicialaiddetail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);