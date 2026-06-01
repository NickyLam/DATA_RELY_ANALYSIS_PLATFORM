/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_pmgg_sfpm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 执行法院
    ,geographicallocation varchar2(4000) -- 所属地域
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,transactionprice varchar2(4000) -- 成交价格
    ,currentprice varchar2(4000) -- 当前价格
    ,startingprice varchar2(4000) -- 起拍价格
    ,auctionname varchar2(4000) -- 拍卖物名称或所有权人
    ,noticecontent varchar2(4000) -- 公告内容
    ,auctionstage varchar2(4000) -- 拍卖阶段
    ,announcedate varchar2(4000) -- 公告日期
    ,closingtime varchar2(4000) -- 成交时间
    ,pmgg_sfpm varchar2(4000) -- 关联标签
    ,casenumber varchar2(4000) -- 执行案号
    ,noticename varchar2(4000) -- 公告名称
    ,auctionstatus varchar2(4000) -- 拍卖状态
    ,startingtime varchar2(4000) -- 起拍时间
    ,name varchar2(4000) -- 被执行人
    ,estimate varchar2(4000) -- 评估值
    ,deposit varchar2(4000) -- 保证金
    ,auctiontype varchar2(4000) -- 拍卖类型
    ,referencecasenumber varchar2(4000) -- 执行依据法律文书
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm is '拍卖公告-司法拍卖';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.punishmentorgan is '执行法院';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.geographicallocation is '所属地域';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.transactionprice is '成交价格';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.currentprice is '当前价格';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.startingprice is '起拍价格';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.auctionname is '拍卖物名称或所有权人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.noticecontent is '公告内容';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.auctionstage is '拍卖阶段';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.announcedate is '公告日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.closingtime is '成交时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.pmgg_sfpm is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.casenumber is '执行案号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.noticename is '公告名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.auctionstatus is '拍卖状态';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.startingtime is '起拍时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.name is '被执行人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.estimate is '评估值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.deposit is '保证金';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.auctiontype is '拍卖类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.referencecasenumber is '执行依据法律文书';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm.etl_timestamp is 'ETL处理时间戳';
