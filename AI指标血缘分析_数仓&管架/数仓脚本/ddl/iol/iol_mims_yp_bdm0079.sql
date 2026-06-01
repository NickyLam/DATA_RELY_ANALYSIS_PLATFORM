/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_bdm0079
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_bdm0079
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_bdm0079 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_bdm0079(
    sccode varchar2(48) -- 押品编号
    ,bil_num varchar2(45) -- 票据号码
    ,bil_amt varchar2(27) -- 票据金额
    ,due_day varchar2(15) -- 到期日
    ,acpt_row_num varchar2(30) -- 承兑行行号
    ,acpt_row_bnk_nm varchar2(150) -- 承兑行行名
    ,impa_dt varchar2(15) -- 质押日期
    ,impa_fname varchar2(300) -- 出质人全称
    ,impa_acct_num varchar2(60) -- 出质人账号
    ,impa_open_bk_num varchar2(30) -- 出质人开户行行号
    ,impa_open_bk_name varchar2(300) -- 出质人开户行行名
    ,csld_soci_crdt_cd varchar2(30) -- 出质人统一社会信用代码
    ,org_num varchar2(30) -- 机构号
    ,pawn_open_bk_name varchar2(30) -- 质权人开户行名
    ,flag varchar2(2) -- 质押标识（0质押 1解质押）
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
grant select on ${iol_schema}.mims_yp_bdm0079 to ${iml_schema};
grant select on ${iol_schema}.mims_yp_bdm0079 to ${icl_schema};
grant select on ${iol_schema}.mims_yp_bdm0079 to ${idl_schema};
grant select on ${iol_schema}.mims_yp_bdm0079 to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_bdm0079 is '纸质票据质押信息表';
comment on column ${iol_schema}.mims_yp_bdm0079.sccode is '押品编号';
comment on column ${iol_schema}.mims_yp_bdm0079.bil_num is '票据号码';
comment on column ${iol_schema}.mims_yp_bdm0079.bil_amt is '票据金额';
comment on column ${iol_schema}.mims_yp_bdm0079.due_day is '到期日';
comment on column ${iol_schema}.mims_yp_bdm0079.acpt_row_num is '承兑行行号';
comment on column ${iol_schema}.mims_yp_bdm0079.acpt_row_bnk_nm is '承兑行行名';
comment on column ${iol_schema}.mims_yp_bdm0079.impa_dt is '质押日期';
comment on column ${iol_schema}.mims_yp_bdm0079.impa_fname is '出质人全称';
comment on column ${iol_schema}.mims_yp_bdm0079.impa_acct_num is '出质人账号';
comment on column ${iol_schema}.mims_yp_bdm0079.impa_open_bk_num is '出质人开户行行号';
comment on column ${iol_schema}.mims_yp_bdm0079.impa_open_bk_name is '出质人开户行行名';
comment on column ${iol_schema}.mims_yp_bdm0079.csld_soci_crdt_cd is '出质人统一社会信用代码';
comment on column ${iol_schema}.mims_yp_bdm0079.org_num is '机构号';
comment on column ${iol_schema}.mims_yp_bdm0079.pawn_open_bk_name is '质权人开户行名';
comment on column ${iol_schema}.mims_yp_bdm0079.flag is '质押标识（0质押 1解质押）';
comment on column ${iol_schema}.mims_yp_bdm0079.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_bdm0079.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_bdm0079.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_bdm0079.etl_timestamp is 'ETL处理时间戳';
