/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_sfsxbzxrdgjk_data_sxbzxr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,zxyjdw varchar2(4000) -- 出执行依据单位
    ,qyfr varchar2(4000) -- 企业法人
    ,zxyjwh varchar2(4000) -- 执行依据文号
    ,larq varchar2(4000) -- 立案时间（日期）
    ,ah varchar2(4000) -- 案号
    ,zxfy varchar2(4000) -- 执行法院
    ,sf varchar2(4000) -- 省份
    ,lxqk varchar2(4000) -- 被执行人的履行情况
    ,fbrq varchar2(4000) -- 发布时间（日期）
    ,data_sxbzxr varchar2(4000) -- 关联标签
    ,zzjgdm varchar2(4000) -- 组织机构代码
    ,yw varchar2(4000) -- 生效法律文书确定的义务
    ,xwqx varchar2(4000) -- 失信被执行人行为具体情形
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
grant select on ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr to ${iml_schema};
grant select on ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr to ${icl_schema};
grant select on ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr to ${idl_schema};
grant select on ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr is '司法研究院监控接口相关数据';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.zxyjdw is '出执行依据单位';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.qyfr is '企业法人';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.zxyjwh is '执行依据文号';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.larq is '立案时间（日期）';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.ah is '案号';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.zxfy is '执行法院';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.sf is '省份';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.lxqk is '被执行人的履行情况';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.fbrq is '发布时间（日期）';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.data_sxbzxr is '关联标签';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.zzjgdm is '组织机构代码';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.yw is '生效法律文书确定的义务';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.xwqx is '失信被执行人行为具体情形';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_sfsxbzxrdgjk_data_sxbzxr.etl_timestamp is 'ETL处理时间戳';
