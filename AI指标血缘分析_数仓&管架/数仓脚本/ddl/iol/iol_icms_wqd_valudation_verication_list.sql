/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wqd_valudation_verication_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wqd_valudation_verication_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wqd_valudation_verication_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wqd_valudation_verication_list(
    serialno varchar2(32) -- 主键
    ,relativeserialno varchar2(32) -- 业务流水号
    ,serno varchar2(20) -- 序号
    ,valuationcompany varchar2(200) -- 评估公司名称
    ,valuationper number(24,6) -- 评估单价
    ,valuationtotal number(24,6) -- 评估总价
    ,buildareach number(24,6) -- 核验面积
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_wqd_valudation_verication_list to ${iml_schema};
grant select on ${iol_schema}.icms_wqd_valudation_verication_list to ${icl_schema};
grant select on ${iol_schema}.icms_wqd_valudation_verication_list to ${idl_schema};
grant select on ${iol_schema}.icms_wqd_valudation_verication_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wqd_valudation_verication_list is '旺企贷评估信息列表';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.serialno is '主键';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.relativeserialno is '业务流水号';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.serno is '序号';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.valuationcompany is '评估公司名称';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.valuationper is '评估单价';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.valuationtotal is '评估总价';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.buildareach is '核验面积';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wqd_valudation_verication_list.etl_timestamp is 'ETL处理时间戳';
