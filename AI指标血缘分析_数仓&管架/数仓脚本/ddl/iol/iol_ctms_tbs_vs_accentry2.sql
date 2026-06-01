/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_accentry2
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_accentry2
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_accentry2 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_accentry2(
    accentry2_id number -- 会计分录2ID
    ,aspclient_id number -- 所属部门ID
    ,keepfolder_id number -- 账户ID
    ,acccode number -- 分录代码
    ,settledate number -- 支付日期
    ,inouttype varchar2(2) -- 表内/表外
    ,debitcredit varchar2(6) -- 借方/贷方
    ,accountingcode varchar2(150) -- 会计科目代码
    ,amount number -- 面额
    ,status varchar2(2) -- 状态
    ,lastmodified timestamp -- 最后修改时间
    ,send_time date -- 发送时间
    ,batchcode varchar2(17) -- 代码批处理
    ,cptycode varchar2(270) -- 交易对手代码
    ,accountingdesc varchar2(300) -- 会计科目描述
    ,bundlecode number -- 代码绑定
    ,note varchar2(300) -- 备注
    ,accentry2_id_rev number -- 冲回分录用来记录被冲分录的ID
    ,rev_flag varchar2(2) -- 冲回分录标记
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ctms_tbs_vs_accentry2 to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_accentry2 to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_accentry2 to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_accentry2 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_accentry2 is '原始账务分录';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.accentry2_id is '会计分录2ID';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.aspclient_id is '所属部门ID';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.acccode is '分录代码';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.settledate is '支付日期';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.inouttype is '表内/表外';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.debitcredit is '借方/贷方';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.accountingcode is '会计科目代码';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.amount is '面额';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.send_time is '发送时间';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.batchcode is '代码批处理';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.cptycode is '交易对手代码';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.accountingdesc is '会计科目描述';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.bundlecode is '代码绑定';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.note is '备注';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.accentry2_id_rev is '冲回分录用来记录被冲分录的ID';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.rev_flag is '冲回分录标记';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_accentry2.etl_timestamp is 'ETL处理时间戳';
