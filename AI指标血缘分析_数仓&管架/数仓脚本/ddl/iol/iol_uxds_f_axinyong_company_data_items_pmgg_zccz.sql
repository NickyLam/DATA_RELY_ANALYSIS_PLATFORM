/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_pmgg_zccz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,itemnumber varchar2(4000) -- 项目编号
    ,targetindustry varchar2(4000) -- 标的行业
    ,itemcontent varchar2(4000) -- 项目内容
    ,itemtype varchar2(4000) -- 项目类型
    ,transferor varchar2(4000) -- 转让方名称
    ,listingenddate varchar2(4000) -- 挂牌期满日期
    ,city varchar2(4000) -- 项目地点（市）
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,pmgg_zccz varchar2(4000) -- 关联标签
    ,announcedate varchar2(4000) -- 发布日期
    ,province varchar2(4000) -- 项目地点（省）
    ,name varchar2(4000) -- 项目名称
    ,objectname varchar2(4000) -- 标的企业名称
    ,exchangename varchar2(4000) -- 交易所名称
    ,listedprice varchar2(4000) -- 挂牌价格
    ,listingstartdate varchar2(4000) -- 挂牌起始日期
    ,region varchar2(4000) -- 项目地点（区）
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz is '拍卖公告-资产处置';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.itemnumber is '项目编号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.targetindustry is '标的行业';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.itemcontent is '项目内容';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.itemtype is '项目类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.transferor is '转让方名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.listingenddate is '挂牌期满日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.city is '项目地点（市）';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.pmgg_zccz is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.announcedate is '发布日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.province is '项目地点（省）';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.name is '项目名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.objectname is '标的企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.exchangename is '交易所名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.listedprice is '挂牌价格';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.listingstartdate is '挂牌起始日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.region is '项目地点（区）';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_zccz.etl_timestamp is 'ETL处理时间戳';
