/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_swcf_swcg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 税务机关
    ,amount varchar2(4000) -- 欠税金额
    ,taxestype varchar2(4000) -- 欠税种类
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,expirydate varchar2(4000) -- 应缴税截至日期
    ,punishcause varchar2(4000) -- 处罚事由
    ,taxpaymentperiod varchar2(4000) -- 税款限缴期限
    ,swcf_swcg varchar2(4000) -- 关联标签
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg is '税务处罚-税务催告';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.punishmentorgan is '税务机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.amount is '欠税金额';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.taxestype is '欠税种类';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.expirydate is '应缴税截至日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.punishcause is '处罚事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.taxpaymentperiod is '税款限缴期限';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.swcf_swcg is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.penaltytime is '处罚日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.casenumber is '文书字号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.name is '纳税主体';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.startdate is '应缴税起始日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_swcg.etl_timestamp is 'ETL处理时间戳';
