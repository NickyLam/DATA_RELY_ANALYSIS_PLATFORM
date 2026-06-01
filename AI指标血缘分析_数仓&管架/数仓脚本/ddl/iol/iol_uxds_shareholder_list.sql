/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_shareholder_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_shareholder_list
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_shareholder_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_shareholder_list(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建日期
    ,mtime date -- 记录修改日期
    ,rtime date -- 记录通讯到用户端日期
    ,held_num number(18,0) -- 持有数量
    ,held_num_res_share number(18,0) -- 持股数量-限售股份
    ,held_num_unlim_share number(18,0) -- 持股数量-无限售股份
    ,held_ratio number(9,4) -- 持有比例
    ,holder_ctgry varchar2(180) -- 股东类别
    ,holder_id varchar2(60) -- 股东id
    ,holder_name varchar2(1500) -- 股东名称
    ,holder_rank number(28,6) -- 股东名次
    ,holder_type_code varchar2(36) -- 股东类别编码
    ,is_holder_org number(1,0) -- 股东是否机构
    ,pledge_num number(18,0) -- 质押数量
    ,publish_date date -- 公布日期
    ,share_ctgry varchar2(240) -- 股份类别
    ,share_pledge_frozen_num number(12,0) -- 股份质押冻结数量
    ,share_type_code varchar2(120) -- 股份类别编码
    ,acting_concert_sign varchar2(30) -- 一致行动人标志
    ,top10_holders_rr_expalin varchar2(4000) -- 前10名股东之间存在关联关系或一致行动人的说明
    ,corp_code varchar2(60) -- 公司代码
    ,ed date -- 截止日期
    ,frozen_num number(18,0) -- 冻结数量
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_shareholder_list to ${iml_schema};
grant select on ${iol_schema}.uxds_shareholder_list to ${icl_schema};
grant select on ${iol_schema}.uxds_shareholder_list to ${idl_schema};
grant select on ${iol_schema}.uxds_shareholder_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_shareholder_list is '中国股票股东名单';
comment on column ${iol_schema}.uxds_shareholder_list.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_shareholder_list.ctime is '记录创建日期';
comment on column ${iol_schema}.uxds_shareholder_list.mtime is '记录修改日期';
comment on column ${iol_schema}.uxds_shareholder_list.rtime is '记录通讯到用户端日期';
comment on column ${iol_schema}.uxds_shareholder_list.held_num is '持有数量';
comment on column ${iol_schema}.uxds_shareholder_list.held_num_res_share is '持股数量-限售股份';
comment on column ${iol_schema}.uxds_shareholder_list.held_num_unlim_share is '持股数量-无限售股份';
comment on column ${iol_schema}.uxds_shareholder_list.held_ratio is '持有比例';
comment on column ${iol_schema}.uxds_shareholder_list.holder_ctgry is '股东类别';
comment on column ${iol_schema}.uxds_shareholder_list.holder_id is '股东id';
comment on column ${iol_schema}.uxds_shareholder_list.holder_name is '股东名称';
comment on column ${iol_schema}.uxds_shareholder_list.holder_rank is '股东名次';
comment on column ${iol_schema}.uxds_shareholder_list.holder_type_code is '股东类别编码';
comment on column ${iol_schema}.uxds_shareholder_list.is_holder_org is '股东是否机构';
comment on column ${iol_schema}.uxds_shareholder_list.pledge_num is '质押数量';
comment on column ${iol_schema}.uxds_shareholder_list.publish_date is '公布日期';
comment on column ${iol_schema}.uxds_shareholder_list.share_ctgry is '股份类别';
comment on column ${iol_schema}.uxds_shareholder_list.share_pledge_frozen_num is '股份质押冻结数量';
comment on column ${iol_schema}.uxds_shareholder_list.share_type_code is '股份类别编码';
comment on column ${iol_schema}.uxds_shareholder_list.acting_concert_sign is '一致行动人标志';
comment on column ${iol_schema}.uxds_shareholder_list.top10_holders_rr_expalin is '前10名股东之间存在关联关系或一致行动人的说明';
comment on column ${iol_schema}.uxds_shareholder_list.corp_code is '公司代码';
comment on column ${iol_schema}.uxds_shareholder_list.ed is '截止日期';
comment on column ${iol_schema}.uxds_shareholder_list.frozen_num is '冻结数量';
comment on column ${iol_schema}.uxds_shareholder_list.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_shareholder_list.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_shareholder_list.etl_timestamp is 'ETL处理时间戳';
