/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ftevatrx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ftevatrx
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ftevatrx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ftevatrx(
    trandt varchar2(12) -- 交易日期
    ,trantrx varchar2(30) -- 交易流水
    ,brchno varchar2(9) -- 机构号
    ,brchnm varchar2(90) -- 机构名
    ,trantlr varchar2(9) -- 交易柜员
    ,trannm varchar2(150) -- 交易名称
    ,fronttrcd varchar2(15) -- 交易码
    ,srcsysid varchar2(6) -- 源系统
    ,srctrndt varchar2(12) -- 系统交易日期
    ,srcseqno varchar2(30) -- 源系统流水号
    ,trnstat varchar2(2) -- 返回码类型 n:正常  e:错误
    ,trancode varchar2(30) -- 交易代码
    ,srctrancode varchar2(30) -- 渠道交易码
    ,jdgdt varchar2(12) -- 评价日期
    ,jdgdttm varchar2(21) -- 评价时间
    ,jdgrslt varchar2(8) -- 评价结果 a 满意 b一般  c不满意  z未评价
    ,sysdt varchar2(12) -- 系统日期
    ,chkflg varchar2(2) -- 是否勾对流水 0 未勾对 1 已勾对 2 无需勾对
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
grant select on ${iol_schema}.mpcs_a0ftevatrx to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ftevatrx to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ftevatrx to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ftevatrx to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ftevatrx is '评价流水表';
comment on column ${iol_schema}.mpcs_a0ftevatrx.trandt is '交易日期';
comment on column ${iol_schema}.mpcs_a0ftevatrx.trantrx is '交易流水';
comment on column ${iol_schema}.mpcs_a0ftevatrx.brchno is '机构号';
comment on column ${iol_schema}.mpcs_a0ftevatrx.brchnm is '机构名';
comment on column ${iol_schema}.mpcs_a0ftevatrx.trantlr is '交易柜员';
comment on column ${iol_schema}.mpcs_a0ftevatrx.trannm is '交易名称';
comment on column ${iol_schema}.mpcs_a0ftevatrx.fronttrcd is '交易码';
comment on column ${iol_schema}.mpcs_a0ftevatrx.srcsysid is '源系统';
comment on column ${iol_schema}.mpcs_a0ftevatrx.srctrndt is '系统交易日期';
comment on column ${iol_schema}.mpcs_a0ftevatrx.srcseqno is '源系统流水号';
comment on column ${iol_schema}.mpcs_a0ftevatrx.trnstat is '返回码类型 n:正常  e:错误';
comment on column ${iol_schema}.mpcs_a0ftevatrx.trancode is '交易代码';
comment on column ${iol_schema}.mpcs_a0ftevatrx.srctrancode is '渠道交易码';
comment on column ${iol_schema}.mpcs_a0ftevatrx.jdgdt is '评价日期';
comment on column ${iol_schema}.mpcs_a0ftevatrx.jdgdttm is '评价时间';
comment on column ${iol_schema}.mpcs_a0ftevatrx.jdgrslt is '评价结果 a 满意 b一般  c不满意  z未评价';
comment on column ${iol_schema}.mpcs_a0ftevatrx.sysdt is '系统日期';
comment on column ${iol_schema}.mpcs_a0ftevatrx.chkflg is '是否勾对流水 0 未勾对 1 已勾对 2 无需勾对';
comment on column ${iol_schema}.mpcs_a0ftevatrx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a0ftevatrx.etl_timestamp is 'ETL处理时间戳';
