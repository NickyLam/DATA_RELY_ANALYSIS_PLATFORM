/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_vs_accentry2
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_vs_accentry2
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_vs_accentry2 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_vs_accentry2(
    accentry2_id number(22,0) -- 分录ID
    ,alterbalance_id number(10,0) -- 资产变动ID
    ,keepfolder_id number(22,0) -- 投组ID
    ,acccode number(22,0) -- 事件
    ,settledate number(22,0) -- 日期
    ,inouttype varchar2(2) -- 表内表外标识
    ,debitcredit varchar2(6) -- 借贷方向
    ,accountingcode varchar2(768) -- 科目
    ,amount number -- 金额
    ,lastmodified timestamp -- 最后更新时间
    ,accountingdesc varchar2(150) -- 科目名称
    ,note varchar2(300) -- 备注
    ,day_end_date number(8,0) -- 日终日
    ,currency_type varchar2(12) -- 币种
    ,ori_accounting_code varchar2(768) -- 映射科目
    ,ori_accounting_desc varchar2(150) -- 映射科目名称
    ,is_mapping varchar2(2) -- 是否科目映射
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
grant select on ${iol_schema}.ctms_fbs_vs_accentry2 to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_vs_accentry2 to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_vs_accentry2 to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_vs_accentry2 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_vs_accentry2 is '分录明细表';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.accentry2_id is '分录ID';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.alterbalance_id is '资产变动ID';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.keepfolder_id is '投组ID';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.acccode is '事件';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.settledate is '日期';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.inouttype is '表内表外标识';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.debitcredit is '借贷方向';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.accountingcode is '科目';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.amount is '金额';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.lastmodified is '最后更新时间';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.accountingdesc is '科目名称';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.note is '备注';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.day_end_date is '日终日';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.currency_type is '币种';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.ori_accounting_code is '映射科目';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.ori_accounting_desc is '映射科目名称';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.is_mapping is '是否科目映射';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_fbs_vs_accentry2.etl_timestamp is 'ETL处理时间戳';
