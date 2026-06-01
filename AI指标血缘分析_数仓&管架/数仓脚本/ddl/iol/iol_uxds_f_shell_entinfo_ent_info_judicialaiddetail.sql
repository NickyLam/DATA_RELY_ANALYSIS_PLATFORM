/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_judicialaiddetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,cfrofrom varchar2(4000) -- 续行冻结期限自
    ,market_credit_code varchar2(4000) -- 被冻结股权所在市场统一社会信用代码
    ,ent_info_judicialaiddetail varchar2(4000) -- 关联标签
    ,id_type varchar2(4000) -- 证件类型
    ,cfroto varchar2(4000) -- 续行冻结期限至
    ,iname_type varchar2(4000) -- 被执行类型
    ,licence_type varchar2(4000) -- 被执行人类型
    ,shaream varchar2(4000) -- 股权数额
    ,expiration_reason varchar2(4000) -- 失效原因
    ,cur varchar2(4000) -- 币种
    ,publicdate varchar2(4000) -- 公示日期
    ,judgment_no varchar2(4000) -- 执行裁定书文号
    ,regist_no varchar2(4000) -- 被冻结股权所在市场主体注册号
    ,execution varchar2(4000) -- 执行事项
    ,freeze_flag varchar2(4000) -- 股权冻结状态
    ,fperiod varchar2(4000) -- 冻结期限
    ,freeze_date varchar2(4000) -- 解冻日期
    ,parent_id varchar2(4000) -- 被执行人ID
    ,expiration_date varchar2(4000) -- 失效日期
    ,frofrom varchar2(4000) -- 冻结期限自
    ,licence_no varchar2(4000) -- 证照编号
    ,ex_notice_no varchar2(4000) -- 协助执行通知书文号
    ,market_name varchar2(4000) -- 被冻结股权所在市场主体名称
    ,cfperiod varchar2(4000) -- 续行冻结期限
    ,iname varchar2(4000) -- 被执行人
    ,froto varchar2(4000) -- 冻结期限至
    ,courtname varchar2(4000) -- 执行法院
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail is '司法协助详情';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.cfrofrom is '续行冻结期限自';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.market_credit_code is '被冻结股权所在市场统一社会信用代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.ent_info_judicialaiddetail is '关联标签';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.id_type is '证件类型';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.cfroto is '续行冻结期限至';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.iname_type is '被执行类型';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.licence_type is '被执行人类型';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.shaream is '股权数额';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.expiration_reason is '失效原因';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.cur is '币种';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.publicdate is '公示日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.judgment_no is '执行裁定书文号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.regist_no is '被冻结股权所在市场主体注册号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.execution is '执行事项';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.freeze_flag is '股权冻结状态';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.fperiod is '冻结期限';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.freeze_date is '解冻日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.parent_id is '被执行人ID';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.expiration_date is '失效日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.frofrom is '冻结期限自';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.licence_no is '证照编号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.ex_notice_no is '协助执行通知书文号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.market_name is '被冻结股权所在市场主体名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.cfperiod is '续行冻结期限';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.iname is '被执行人';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.froto is '冻结期限至';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.courtname is '执行法院';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_judicialaiddetail.etl_timestamp is 'ETL处理时间戳';
