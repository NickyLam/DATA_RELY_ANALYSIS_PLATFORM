/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60fmpsignmag
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60fmpsignmag
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60fmpsignmag purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60fmpsignmag(
    status varchar2(2) -- 签约状态
    ,signdate varchar2(12) -- 签约日期
    ,signtime varchar2(9) -- 签约时间
    ,oprbrn varchar2(9) -- 操作机构
    ,oprtlr varchar2(12) -- 操作柜员
    ,chkbrn varchar2(9) -- 复核机构
    ,chktlr varchar2(9) -- 复核柜员
    ,autbrn varchar2(9) -- 授权机构
    ,auttlr varchar2(9) -- 授权柜员
    ,bankaccount varchar2(75) -- 监控账号
    ,presalecode varchar2(30) -- 预售证号
    ,companyname varchar2(150) -- 开发公司
    ,projectname varchar2(150) -- 项目名称
    ,contactnum varchar2(30) -- 联系电话
    ,contactadd varchar2(450) -- 联系地址
    ,recommend varchar2(30) -- 推荐人
    ,remarks varchar2(450) -- 备注
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
grant select on ${iol_schema}.mpcs_a60fmpsignmag to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60fmpsignmag to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60fmpsignmag to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60fmpsignmag to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60fmpsignmag is '签约信息管理表';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.status is '签约状态';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.signdate is '签约日期';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.signtime is '签约时间';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.oprbrn is '操作机构';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.oprtlr is '操作柜员';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.chkbrn is '复核机构';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.chktlr is '复核柜员';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.autbrn is '授权机构';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.auttlr is '授权柜员';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.bankaccount is '监控账号';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.presalecode is '预售证号';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.companyname is '开发公司';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.projectname is '项目名称';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.contactnum is '联系电话';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.contactadd is '联系地址';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.recommend is '推荐人';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.remarks is '备注';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a60fmpsignmag.etl_timestamp is 'ETL处理时间戳';
