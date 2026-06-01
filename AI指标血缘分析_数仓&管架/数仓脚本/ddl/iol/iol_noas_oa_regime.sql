/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_regime
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_regime
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_regime purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_regime(
    regime_id varchar2(30) -- 制度标识
    ,flow_type_id varchar2(30) -- 当前流程id
    ,regime_name varchar2(383) -- 制度名称
    ,data_type varchar2(30) -- 类别(1-合规2-未分类)
    ,character_num varchar2(383) -- 文号
    ,version_num varchar2(383) -- 版本号
    ,regime_type varchar2(30) -- 制度类型(总行:1-基本制度,2-管理办法,3-操作规范分行:1-管理办法2-操作规范)
    ,attachment_id varchar2(383) -- 附件id
    ,formulate_date date -- 拟稿时间
    ,validity_date varchar2(30) -- 有效期(年)
    ,regime_status varchar2(30) -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
    ,formulate_dept varchar2(383) -- 制定部门(拟稿人部门)
    ,release_person varchar2(383) -- 发布人
    ,release_dept varchar2(383) -- 发布部门(发布人所在部门)
    ,release_status varchar2(30) -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
    ,remark varchar2(4000) -- 备注
    ,detail varchar2(383) -- 内容
    ,allow_reader varchar2(383) -- 允许读者
    ,release_date date -- 签发时间
    ,last_updated_stamp timestamp -- bosent自带最后修改时间
    ,last_updated_tx_stamp timestamp -- bosent自带最后修改时间
    ,created_stamp timestamp -- bosent自带创建时间
    ,created_tx_stamp timestamp -- bosent自带创建时间
    ,process_ins_id varchar2(90) -- 流程实例id
    ,useful_time varchar2(30) -- 版本有效期截止时间
    ,sign_leader varchar2(383) -- 签发人
    ,writter varchar2(383) -- 拟稿人姓名
    ,abolish_date date -- 制度废止时间
    ,business_dimension varchar2(90) -- 业务维度
    ,abolish_person varchar2(383) -- 制度废止人姓名
    ,security_level varchar2(30) -- 安全级别(1-全行可见,2-总行和本分行可见)
    ,abolish_type varchar2(90) -- 废止经办(1-系统废止/2-手动废止人员姓名)
    ,abolish_oper_time date -- 废止操作
    ,abolish_source varchar2(782) -- 制度废止原因(《关于废止**办法的通知》（粤华银发[2017]**号）)
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
grant select on ${iol_schema}.noas_oa_regime to ${iml_schema};
grant select on ${iol_schema}.noas_oa_regime to ${icl_schema};
grant select on ${iol_schema}.noas_oa_regime to ${idl_schema};
grant select on ${iol_schema}.noas_oa_regime to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_regime is '规章制度基本信息';
comment on column ${iol_schema}.noas_oa_regime.regime_id is '制度标识';
comment on column ${iol_schema}.noas_oa_regime.flow_type_id is '当前流程id';
comment on column ${iol_schema}.noas_oa_regime.regime_name is '制度名称';
comment on column ${iol_schema}.noas_oa_regime.data_type is '类别(1-合规2-未分类)';
comment on column ${iol_schema}.noas_oa_regime.character_num is '文号';
comment on column ${iol_schema}.noas_oa_regime.version_num is '版本号';
comment on column ${iol_schema}.noas_oa_regime.regime_type is '制度类型(总行:1-基本制度,2-管理办法,3-操作规范分行:1-管理办法2-操作规范)';
comment on column ${iol_schema}.noas_oa_regime.attachment_id is '附件id';
comment on column ${iol_schema}.noas_oa_regime.formulate_date is '拟稿时间';
comment on column ${iol_schema}.noas_oa_regime.validity_date is '有效期(年)';
comment on column ${iol_schema}.noas_oa_regime.regime_status is '制度状态(1-有效,2-修订,3-废止,4-有效期限届满)';
comment on column ${iol_schema}.noas_oa_regime.formulate_dept is '制定部门(拟稿人部门)';
comment on column ${iol_schema}.noas_oa_regime.release_person is '发布人';
comment on column ${iol_schema}.noas_oa_regime.release_dept is '发布部门(发布人所在部门)';
comment on column ${iol_schema}.noas_oa_regime.release_status is '制度状态(1-有效,2-修订,3-废止,4-有效期限届满)';
comment on column ${iol_schema}.noas_oa_regime.remark is '备注';
comment on column ${iol_schema}.noas_oa_regime.detail is '内容';
comment on column ${iol_schema}.noas_oa_regime.allow_reader is '允许读者';
comment on column ${iol_schema}.noas_oa_regime.release_date is '签发时间';
comment on column ${iol_schema}.noas_oa_regime.last_updated_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_oa_regime.last_updated_tx_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_oa_regime.created_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_oa_regime.created_tx_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_oa_regime.process_ins_id is '流程实例id';
comment on column ${iol_schema}.noas_oa_regime.useful_time is '版本有效期截止时间';
comment on column ${iol_schema}.noas_oa_regime.sign_leader is '签发人';
comment on column ${iol_schema}.noas_oa_regime.writter is '拟稿人姓名';
comment on column ${iol_schema}.noas_oa_regime.abolish_date is '制度废止时间';
comment on column ${iol_schema}.noas_oa_regime.business_dimension is '业务维度';
comment on column ${iol_schema}.noas_oa_regime.abolish_person is '制度废止人姓名';
comment on column ${iol_schema}.noas_oa_regime.security_level is '安全级别(1-全行可见,2-总行和本分行可见)';
comment on column ${iol_schema}.noas_oa_regime.abolish_type is '废止经办(1-系统废止/2-手动废止人员姓名)';
comment on column ${iol_schema}.noas_oa_regime.abolish_oper_time is '废止操作';
comment on column ${iol_schema}.noas_oa_regime.abolish_source is '制度废止原因(《关于废止**办法的通知》（粤华银发[2017]**号）)';
comment on column ${iol_schema}.noas_oa_regime.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_regime.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_regime.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_regime.etl_timestamp is 'ETL处理时间戳';
