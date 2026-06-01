/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_ecif
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_ecif
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_ecif purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_ecif(
    pei_ecifno varchar2(32) -- 全行统一客户号
    ,pei_userno varchar2(32) -- 用户顺序号
    ,pei_state varchar2(3) -- 状态
    ,pei_opendate varchar2(14) -- 开户日期
    ,pei_cllosedate varchar2(14) -- 注销日期
    ,pei_staffflag varchar2(1) -- 是否行内员工
    ,pei_namecn varchar2(120) -- 客户姓名
    ,pei_nameen varchar2(80) -- 客户英文名
    ,pei_ctftype varchar2(4) -- 证件类型
    ,pei_ctfno varchar2(32) -- 证件号
    ,pei_address varchar2(300) -- 联系地址
    ,pei_phone varchar2(32) -- 联系电话
    ,pei_zipcode varchar2(6) -- 邮政编码
    ,pei_email varchar2(50) -- 邮箱
    ,pei_mobile varchar2(30) -- 手机号码
    ,pei_sex varchar2(1) -- 性别
    ,pei_tel varchar2(32) -- 办公电话
    ,pei_bankid varchar2(32) -- 银行编码
    ,pei_bankname varchar2(128) -- 银行名称
    ,pei_branchid varchar2(16) -- 分行号
    ,pei_branchname varchar2(64) -- 分行名称
    ,pei_deptid varchar2(32) -- 机构号
    ,pei_deptname varchar2(256) -- 机构名称
    ,pei_nationality varchar2(10) -- 国家
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
grant select on ${iol_schema}.osbs_pbs_ecif to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_ecif to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_ecif to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_ecif to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_ecif is '个人客户信息表（ecif）';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_state is '状态';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_opendate is '开户日期';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_cllosedate is '注销日期';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_staffflag is '是否行内员工';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_namecn is '客户姓名';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_nameen is '客户英文名';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_ctftype is '证件类型';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_ctfno is '证件号';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_address is '联系地址';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_phone is '联系电话';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_zipcode is '邮政编码';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_email is '邮箱';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_mobile is '手机号码';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_sex is '性别';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_tel is '办公电话';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_bankid is '银行编码';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_bankname is '银行名称';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_branchid is '分行号';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_branchname is '分行名称';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_deptid is '机构号';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_deptname is '机构名称';
comment on column ${iol_schema}.osbs_pbs_ecif.pei_nationality is '国家';
comment on column ${iol_schema}.osbs_pbs_ecif.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_pbs_ecif.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_pbs_ecif.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_pbs_ecif.etl_timestamp is 'ETL处理时间戳';
