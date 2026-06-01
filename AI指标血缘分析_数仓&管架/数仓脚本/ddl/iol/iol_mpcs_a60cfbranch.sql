/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60cfbranch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60cfbranch
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60cfbranch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60cfbranch(
    brnnbr varchar2(9) -- 机构号
    ,brnlevel varchar2(3) -- 机构级别
    ,brntype varchar2(2) -- 机构属性
    ,deptype varchar2(6) -- 部门类别
    ,upperbrn varchar2(9) -- 直接上级机构号
    ,citycode varchar2(9) -- 机构所在城市码
    ,clearcitycode varchar2(9) -- 人行清算业务所属的城市
    ,brnname varchar2(90) -- 机构名称
    ,brnexname varchar2(93) -- 机构名称扩展
    ,innclt varchar2(15) -- 内部客户号
    ,ledgerbrn varchar2(9) -- 总账核算机构
    ,actflag varchar2(2) -- 明细账机构标志
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
grant select on ${iol_schema}.mpcs_a60cfbranch to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60cfbranch to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60cfbranch to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60cfbranch to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60cfbranch is '';
comment on column ${iol_schema}.mpcs_a60cfbranch.brnnbr is '机构号';
comment on column ${iol_schema}.mpcs_a60cfbranch.brnlevel is '机构级别';
comment on column ${iol_schema}.mpcs_a60cfbranch.brntype is '机构属性';
comment on column ${iol_schema}.mpcs_a60cfbranch.deptype is '部门类别';
comment on column ${iol_schema}.mpcs_a60cfbranch.upperbrn is '直接上级机构号';
comment on column ${iol_schema}.mpcs_a60cfbranch.citycode is '机构所在城市码';
comment on column ${iol_schema}.mpcs_a60cfbranch.clearcitycode is '人行清算业务所属的城市';
comment on column ${iol_schema}.mpcs_a60cfbranch.brnname is '机构名称';
comment on column ${iol_schema}.mpcs_a60cfbranch.brnexname is '机构名称扩展';
comment on column ${iol_schema}.mpcs_a60cfbranch.innclt is '内部客户号';
comment on column ${iol_schema}.mpcs_a60cfbranch.ledgerbrn is '总账核算机构';
comment on column ${iol_schema}.mpcs_a60cfbranch.actflag is '明细账机构标志';
comment on column ${iol_schema}.mpcs_a60cfbranch.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a60cfbranch.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a60cfbranch.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a60cfbranch.etl_timestamp is 'ETL处理时间戳';
