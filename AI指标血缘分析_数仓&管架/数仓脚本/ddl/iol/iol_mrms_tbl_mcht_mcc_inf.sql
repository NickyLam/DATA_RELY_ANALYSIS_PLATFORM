/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_mcht_mcc_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_mcht_mcc_inf
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_mcht_mcc_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_mcht_mcc_inf(
    mchnt_tp varchar2(6) -- mcc号
    ,mchnt_tp_grp varchar2(6) -- 商户组别
    ,descr varchar2(384) -- mcc描述
    ,fee_rate varchar2(12) -- 费率
    ,remark varchar2(384) -- 备注
    ,last_oper_in varchar2(2) -- 最后操作状态(新增,修改)
    ,rec_st varchar2(2) -- 记录状态
    ,rec_upd_usr_id varchar2(60) -- 最后更新柜员id
    ,rec_upd_ts varchar2(21) -- 更新时间
    ,rec_crt_ts varchar2(21) -- 创建时间
    ,reserved varchar2(48) -- 商户分类
    ,debitfee varchar2(12) -- 借记卡费率
    ,creditfee varchar2(12) -- 贷记卡费率
    ,credittopamt varchar2(27) -- 贷记卡封顶金额
    ,debittopamt varchar2(27) -- 借记卡封顶金额
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
grant select on ${iol_schema}.mrms_tbl_mcht_mcc_inf to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_mcht_mcc_inf to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_mcht_mcc_inf to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_mcht_mcc_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_mcht_mcc_inf is '商户mcc信息';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.mchnt_tp is 'mcc号';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.mchnt_tp_grp is '商户组别';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.descr is 'mcc描述';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.fee_rate is '费率';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.remark is '备注';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.last_oper_in is '最后操作状态(新增,修改)';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.rec_st is '记录状态';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.rec_upd_usr_id is '最后更新柜员id';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.rec_upd_ts is '更新时间';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.rec_crt_ts is '创建时间';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.reserved is '商户分类';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.debitfee is '借记卡费率';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.creditfee is '贷记卡费率';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.credittopamt is '贷记卡封顶金额';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.debittopamt is '借记卡封顶金额';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_mcht_mcc_inf.etl_timestamp is 'ETL处理时间戳';
