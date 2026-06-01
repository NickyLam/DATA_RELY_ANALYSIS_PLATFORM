/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_otherguar
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_otherguar
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_otherguar purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_otherguar(
    seqno varchar2(40) -- 序号
    ,clrid varchar2(32) -- 押品编号
    ,seqnumber varchar2(9) -- 我行担保权优先受偿权顺序 0-个人客户,1-法人客户，2-特殊/法人担保客户，3-特殊/个人担保客户，4-个人股东客户，5-法人股东客户（共有人可有多个）
    ,otherbankname varchar2(200) -- 已设定担保权他行名称
    ,othermoney number(20,4) -- 他行设定担保权金额
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_otherguar to ${iml_schema};
grant select on ${iol_schema}.icms_clr_otherguar to ${icl_schema};
grant select on ${iol_schema}.icms_clr_otherguar to ${idl_schema};
grant select on ${iol_schema}.icms_clr_otherguar to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_otherguar is '押品他行担保信息';
comment on column ${iol_schema}.icms_clr_otherguar.seqno is '序号';
comment on column ${iol_schema}.icms_clr_otherguar.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_otherguar.seqnumber is '我行担保权优先受偿权顺序 0-个人客户,1-法人客户，2-特殊/法人担保客户，3-特殊/个人担保客户，4-个人股东客户，5-法人股东客户（共有人可有多个）';
comment on column ${iol_schema}.icms_clr_otherguar.otherbankname is '已设定担保权他行名称';
comment on column ${iol_schema}.icms_clr_otherguar.othermoney is '他行设定担保权金额';
comment on column ${iol_schema}.icms_clr_otherguar.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_otherguar.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_otherguar.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_otherguar.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_otherguar.etl_timestamp is 'ETL处理时间戳';
