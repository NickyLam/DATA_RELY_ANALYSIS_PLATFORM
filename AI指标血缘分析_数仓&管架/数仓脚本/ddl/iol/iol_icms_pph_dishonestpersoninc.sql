/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_pph_dishonestpersoninc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_pph_dishonestpersoninc
whenever sqlerror continue none;
drop table ${iol_schema}.icms_pph_dishonestpersoninc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_pph_dishonestpersoninc(
    serialno varchar2(32) -- 主键ID
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,caseno varchar2(300) -- 案号
    ,ptype varchar2(200) -- 失信人类型
    ,inputdate varchar2(20) -- 登记时间
    ,fulfildesc varchar2(4000) -- 被执行人的履行情况
    ,fufiled varchar2(4000) -- 已履行
    ,executecourt varchar2(900) -- 执行法院
    ,username varchar2(900) -- 被执行人姓名/名称
    ,pubdate varchar2(150) -- 发布时间
    ,age varchar2(96) -- 年龄
    ,idcardsignaddress varchar2(900) -- 身份证原始发证地
    ,customerid varchar2(32) -- 内部客户号
    ,aggreusername varchar2(900) -- 法定代表人/负责人姓名
    ,obligation varchar2(2000) -- 生效法律文书确定的义务
    ,showexecutereasonorg varchar2(900) -- 做出执行依据单位
    ,province varchar2(150) -- 省份
    ,executefileno varchar2(300) -- 执行依据文号
    ,behaviordesc varchar2(4000) -- 失信被执行人行为具体情形
    ,unfulfiled varchar2(900) -- 未履行
    ,idno varchar2(150) -- 身份证号码/工商注册号
    ,regdate varchar2(150) -- 立案时间
    ,sex varchar2(108) -- 性别
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
grant select on ${iol_schema}.icms_pph_dishonestpersoninc to ${iml_schema};
grant select on ${iol_schema}.icms_pph_dishonestpersoninc to ${icl_schema};
grant select on ${iol_schema}.icms_pph_dishonestpersoninc to ${idl_schema};
grant select on ${iol_schema}.icms_pph_dishonestpersoninc to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_pph_dishonestpersoninc is '失信被执行人信息';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.serialno is '主键ID';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.caseno is '案号';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.ptype is '失信人类型';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.inputdate is '登记时间';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.fulfildesc is '被执行人的履行情况';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.fufiled is '已履行';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.executecourt is '执行法院';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.username is '被执行人姓名/名称';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.pubdate is '发布时间';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.age is '年龄';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.idcardsignaddress is '身份证原始发证地';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.customerid is '内部客户号';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.aggreusername is '法定代表人/负责人姓名';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.obligation is '生效法律文书确定的义务';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.showexecutereasonorg is '做出执行依据单位';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.province is '省份';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.executefileno is '执行依据文号';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.behaviordesc is '失信被执行人行为具体情形';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.unfulfiled is '未履行';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.idno is '身份证号码/工商注册号';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.regdate is '立案时间';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.sex is '性别';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.start_dt is '开始时间';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.end_dt is '结束时间';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.id_mark is '增删标志';
comment on column ${iol_schema}.icms_pph_dishonestpersoninc.etl_timestamp is 'ETL处理时间戳';
