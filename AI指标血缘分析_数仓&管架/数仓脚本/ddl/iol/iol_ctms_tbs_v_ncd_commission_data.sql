/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_ncd_commission_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_ncd_commission_data
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_ncd_commission_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_ncd_commission_data(
    ncd_commission_data_id number -- ID
    ,aspclient_id number -- 部门代号
    ,datasymbol_id number -- 数据源ID
    ,serial_num number -- 交易序号
    ,cus_number number(5,0) -- 机构号
    ,ncd_issue_serial varchar2(23) -- 债券发行序号
    ,security_code varchar2(24) -- 债券代码
    ,bidder varchar2(384) -- 申购机构/投标机构
    ,bidder_seq varchar2(384) -- 中标人序号
    ,partydetailaltid varchar2(450) -- 交易接口
    ,bid_amount_cstp number -- 持有量
    ,pf_amount_cstp number -- 应缴款金额
    ,net_commission_amt_cstp number -- 实缴款金额
    ,bid_amount number -- 持有量
    ,pf_amount number -- 应缴款金额
    ,net_commission_amt number -- 实缴款金额
    ,modify_date date -- 修改日期
    ,modify_user number(5,0) -- 修改人
    ,status varchar2(2) -- 状态
    ,cstp_seq number -- 序号
    ,commission_status varchar2(2) -- 缴款状态
    ,ris_indctr varchar2(2) -- 增发标识
    ,ris_tms number -- 增发期数
    ,sort_no number -- 增发序号
    ,lastmodified timestamp -- 最后修改时间
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
grant select on ${iol_schema}.ctms_tbs_v_ncd_commission_data to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_ncd_commission_data to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_ncd_commission_data to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_ncd_commission_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_ncd_commission_data is '债券发行结果缴款汇总信息';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.ncd_commission_data_id is 'ID';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.aspclient_id is '部门代号';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.datasymbol_id is '数据源ID';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.serial_num is '交易序号';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.cus_number is '机构号';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.ncd_issue_serial is '债券发行序号';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.bidder is '申购机构/投标机构';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.bidder_seq is '中标人序号';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.partydetailaltid is '交易接口';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.bid_amount_cstp is '持有量';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.pf_amount_cstp is '应缴款金额';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.net_commission_amt_cstp is '实缴款金额';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.bid_amount is '持有量';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.pf_amount is '应缴款金额';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.net_commission_amt is '实缴款金额';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.modify_date is '修改日期';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.modify_user is '修改人';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.status is '状态';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.cstp_seq is '序号';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.commission_status is '缴款状态';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.ris_indctr is '增发标识';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.ris_tms is '增发期数';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.sort_no is '增发序号';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_ncd_commission_data.etl_timestamp is 'ETL处理时间戳';
