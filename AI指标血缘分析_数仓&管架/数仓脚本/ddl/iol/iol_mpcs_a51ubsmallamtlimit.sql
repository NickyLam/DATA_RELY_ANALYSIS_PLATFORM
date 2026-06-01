/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubsmallamtlimit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubsmallamtlimit
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubsmallamtlimit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubsmallamtlimit(
    acctno varchar2(60) -- 账号
    ,ifpwd varchar2(2) -- 小额免密标识 0-免密 1-验密
    ,systrace varchar2(23) -- 交易流水
    ,chnlid varchar2(15) -- 渠道编码
    ,brchno varchar2(15) -- 机构
    ,opid varchar2(30) -- 操作柜员
    ,quotamt varchar2(30) -- 单笔限额
    ,dayamt varchar2(30) -- 单日累计限额
    ,updtime varchar2(30) -- 操作时间
    ,remark1 varchar2(300) -- 
    ,remark2 varchar2(300) -- 
    ,remark3 varchar2(300) -- 
    ,remark4 varchar2(300) -- 
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
grant select on ${iol_schema}.mpcs_a51ubsmallamtlimit to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubsmallamtlimit to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubsmallamtlimit to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubsmallamtlimit to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubsmallamtlimit is '小额免密限额登记表';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.acctno is '账号';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.ifpwd is '小额免密标识 0-免密 1-验密';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.systrace is '交易流水';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.chnlid is '渠道编码';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.brchno is '机构';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.opid is '操作柜员';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.quotamt is '单笔限额';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.dayamt is '单日累计限额';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.updtime is '操作时间';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.remark1 is '';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.remark2 is '';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.remark3 is '';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.remark4 is '';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a51ubsmallamtlimit.etl_timestamp is 'ETL处理时间戳';
