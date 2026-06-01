/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_swcf_zlzg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 税务机关
    ,amount varchar2(4000) -- 欠税金额
    ,swcf_zlzg varchar2(4000) -- 关联标签
    ,taxestype varchar2(4000) -- 欠税种类
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,expirydate varchar2(4000) -- 应缴税截至日期
    ,punishcause varchar2(4000) -- 处罚事由
    ,taxpaymentperiod varchar2(4000) -- 税款限缴期限
    ,penaltytime varchar2(4000) -- 处罚日期
    ,casenumber varchar2(4000) -- 文书字号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 纳税主体
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,startdate varchar2(4000) -- 应缴税起始日期
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg is '税务处罚-责令整改';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.punishmentorgan is '税务机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.amount is '欠税金额';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.swcf_zlzg is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.taxestype is '欠税种类';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.expirydate is '应缴税截至日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.punishcause is '处罚事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.taxpaymentperiod is '税款限缴期限';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.penaltytime is '处罚日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.casenumber is '文书字号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.name is '纳税主体';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.startdate is '应缴税起始日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_zlzg.etl_timestamp is 'ETL处理时间戳';
