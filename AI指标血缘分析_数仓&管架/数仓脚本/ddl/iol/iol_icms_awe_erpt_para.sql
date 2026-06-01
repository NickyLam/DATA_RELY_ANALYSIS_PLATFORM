/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_awe_erpt_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_awe_erpt_para
whenever sqlerror continue none;
drop table ${iol_schema}.icms_awe_erpt_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_awe_erpt_para(
    orgid varchar2(32) -- 组织机构号
    ,docid varchar2(32) -- 调查报告模板编号
    ,docname varchar2(80) -- 模板名称
    ,remark varchar2(200) -- 备注
    ,updatedate date -- 更新日期
    ,defaultvalue varchar2(500) -- 默认打印节点
    ,attribute1 varchar2(80) -- 属性1
    ,attribute2 varchar2(80) -- 属性2
    ,updateuser varchar2(32) -- 更新人
    ,inputtime date -- 登记日期
    ,inputuser varchar2(32) -- 登记人
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
grant select on ${iol_schema}.icms_awe_erpt_para to ${iml_schema};
grant select on ${iol_schema}.icms_awe_erpt_para to ${icl_schema};
grant select on ${iol_schema}.icms_awe_erpt_para to ${idl_schema};
grant select on ${iol_schema}.icms_awe_erpt_para to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_awe_erpt_para is '调查报告参数表调查报告参数表';
comment on column ${iol_schema}.icms_awe_erpt_para.orgid is '组织机构号';
comment on column ${iol_schema}.icms_awe_erpt_para.docid is '调查报告模板编号';
comment on column ${iol_schema}.icms_awe_erpt_para.docname is '模板名称';
comment on column ${iol_schema}.icms_awe_erpt_para.remark is '备注';
comment on column ${iol_schema}.icms_awe_erpt_para.updatedate is '更新日期';
comment on column ${iol_schema}.icms_awe_erpt_para.defaultvalue is '默认打印节点';
comment on column ${iol_schema}.icms_awe_erpt_para.attribute1 is '属性1';
comment on column ${iol_schema}.icms_awe_erpt_para.attribute2 is '属性2';
comment on column ${iol_schema}.icms_awe_erpt_para.updateuser is '更新人';
comment on column ${iol_schema}.icms_awe_erpt_para.inputtime is '登记日期';
comment on column ${iol_schema}.icms_awe_erpt_para.inputuser is '登记人';
comment on column ${iol_schema}.icms_awe_erpt_para.start_dt is '开始时间';
comment on column ${iol_schema}.icms_awe_erpt_para.end_dt is '结束时间';
comment on column ${iol_schema}.icms_awe_erpt_para.id_mark is '增删标志';
comment on column ${iol_schema}.icms_awe_erpt_para.etl_timestamp is 'ETL处理时间戳';
