/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tag_term_final_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tag_term_final_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tag_term_final_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tag_term_final_data(
    tagid varchar2(32) -- 标签编号
    ,taghirearchy varchar2(10) -- 标签层级
    ,objectno varchar2(64) -- 业务流水号
    ,tagtype varchar2(64) -- 标签类型
    ,reltagflowno varchar2(64) -- 关联流程编号
    ,tagkey varchar2(2000) -- 标签键
    ,tagvalue varchar2(4000) -- 标签值
    ,oldtagvalue varchar2(4000) -- 旧标签值
    ,tagname varchar2(2000) -- 标签名称
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_tag_term_final_data to ${iml_schema};
grant select on ${iol_schema}.icms_tag_term_final_data to ${icl_schema};
grant select on ${iol_schema}.icms_tag_term_final_data to ${idl_schema};
grant select on ${iol_schema}.icms_tag_term_final_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tag_term_final_data is '标签值最终表';
comment on column ${iol_schema}.icms_tag_term_final_data.tagid is '标签编号';
comment on column ${iol_schema}.icms_tag_term_final_data.taghirearchy is '标签层级';
comment on column ${iol_schema}.icms_tag_term_final_data.objectno is '业务流水号';
comment on column ${iol_schema}.icms_tag_term_final_data.tagtype is '标签类型';
comment on column ${iol_schema}.icms_tag_term_final_data.reltagflowno is '关联流程编号';
comment on column ${iol_schema}.icms_tag_term_final_data.tagkey is '标签键';
comment on column ${iol_schema}.icms_tag_term_final_data.tagvalue is '标签值';
comment on column ${iol_schema}.icms_tag_term_final_data.oldtagvalue is '旧标签值';
comment on column ${iol_schema}.icms_tag_term_final_data.tagname is '标签名称';
comment on column ${iol_schema}.icms_tag_term_final_data.inputuserid is '登记人';
comment on column ${iol_schema}.icms_tag_term_final_data.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_tag_term_final_data.inputdate is '登记日期';
comment on column ${iol_schema}.icms_tag_term_final_data.updateuserid is '更新人';
comment on column ${iol_schema}.icms_tag_term_final_data.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_tag_term_final_data.updatedate is '更新日期';
comment on column ${iol_schema}.icms_tag_term_final_data.start_dt is '开始时间';
comment on column ${iol_schema}.icms_tag_term_final_data.end_dt is '结束时间';
comment on column ${iol_schema}.icms_tag_term_final_data.id_mark is '增删标志';
comment on column ${iol_schema}.icms_tag_term_final_data.etl_timestamp is 'ETL处理时间戳';
