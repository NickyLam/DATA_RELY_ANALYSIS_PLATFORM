/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_yzgais02002
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_yzgais02002
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_yzgais02002 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_yzgais02002(
    gendate varchar2(4000) -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,handleracclist_handleracc varchar2(4000) -- handlerAccList_handlerAcc
    ,legalentitycorplist_legalentitycorp varchar2(4000) -- legalEntityCorpList_legalEntityCorp
    ,corpbizrecordlist_corpbizrecord varchar2(4000) -- corpBizRecordList_corpBizRecord
    ,legalentityacclist_legalentityacc varchar2(4000) -- legalEntityAccList_legalEntityAcc
    ,handlertelacclist_handlertelacc varchar2(4000) -- handlerTelAccList_handlerTelAcc
    ,legalpayabnormalcaselist_legalpayabnormalcase varchar2(4000) -- legalPayAbnormalCaseList_legalPayAbnormalCase
    ,addrsimilaracclist_addrsimilaracc varchar2(4000) -- addrSimilarAccList_addrSimilarAcc
    ,ydkhlist_ydkh varchar2(4000) -- ydkhList_ydkh
    ,creditinfolist_creditinfo varchar2(4000) -- creditInfoList_creditInfo
    ,legalaccnamelist_legalaccname varchar2(4000) -- legalAccNameList_legalAccName
    ,legaltelacclist_legaltelacc varchar2(4000) -- legalTelAccList_legalTelAcc
    ,abnormalcaselist_abnormalcase varchar2(4000) -- abnormalCaseList_abnormalCase
    ,itemcode varchar2(4000) -- 查询结果代码
    ,iteminfo varchar2(4000) -- 查询结果描述
    ,genmonth varchar2(4000) -- 生成月份
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
grant select on ${iol_schema}.uxds_f_yzgais02002 to ${iml_schema};
grant select on ${iol_schema}.uxds_f_yzgais02002 to ${icl_schema};
grant select on ${iol_schema}.uxds_f_yzgais02002 to ${idl_schema};
grant select on ${iol_schema}.uxds_f_yzgais02002 to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_yzgais02002 is '粤账管-11项实时检测查询-响应表';
comment on column ${iol_schema}.uxds_f_yzgais02002.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_yzgais02002.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_yzgais02002.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_yzgais02002.handleracclist_handleracc is 'handlerAccList_handlerAcc';
comment on column ${iol_schema}.uxds_f_yzgais02002.legalentitycorplist_legalentitycorp is 'legalEntityCorpList_legalEntityCorp';
comment on column ${iol_schema}.uxds_f_yzgais02002.corpbizrecordlist_corpbizrecord is 'corpBizRecordList_corpBizRecord';
comment on column ${iol_schema}.uxds_f_yzgais02002.legalentityacclist_legalentityacc is 'legalEntityAccList_legalEntityAcc';
comment on column ${iol_schema}.uxds_f_yzgais02002.handlertelacclist_handlertelacc is 'handlerTelAccList_handlerTelAcc';
comment on column ${iol_schema}.uxds_f_yzgais02002.legalpayabnormalcaselist_legalpayabnormalcase is 'legalPayAbnormalCaseList_legalPayAbnormalCase';
comment on column ${iol_schema}.uxds_f_yzgais02002.addrsimilaracclist_addrsimilaracc is 'addrSimilarAccList_addrSimilarAcc';
comment on column ${iol_schema}.uxds_f_yzgais02002.ydkhlist_ydkh is 'ydkhList_ydkh';
comment on column ${iol_schema}.uxds_f_yzgais02002.creditinfolist_creditinfo is 'creditInfoList_creditInfo';
comment on column ${iol_schema}.uxds_f_yzgais02002.legalaccnamelist_legalaccname is 'legalAccNameList_legalAccName';
comment on column ${iol_schema}.uxds_f_yzgais02002.legaltelacclist_legaltelacc is 'legalTelAccList_legalTelAcc';
comment on column ${iol_schema}.uxds_f_yzgais02002.abnormalcaselist_abnormalcase is 'abnormalCaseList_abnormalCase';
comment on column ${iol_schema}.uxds_f_yzgais02002.itemcode is '查询结果代码';
comment on column ${iol_schema}.uxds_f_yzgais02002.iteminfo is '查询结果描述';
comment on column ${iol_schema}.uxds_f_yzgais02002.genmonth is '生成月份';
comment on column ${iol_schema}.uxds_f_yzgais02002.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_yzgais02002.etl_timestamp is 'ETL处理时间戳';
