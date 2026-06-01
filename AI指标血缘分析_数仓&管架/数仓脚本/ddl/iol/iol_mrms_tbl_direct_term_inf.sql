/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_direct_term_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_direct_term_inf
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_direct_term_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_direct_term_inf(
    term_cd varchar2(12) -- 编号
    ,term_sn varchar2(23) -- 机身号
    ,mcht_no varchar2(23) -- 商户编号
    ,term_type varchar2(5) -- 型号id
    ,use varchar2(15) -- 
    ,status varchar2(3) -- 状态
    ,comments varchar2(383) -- 备注
    ,recover varchar2(9) -- 回收
    ,order_dt varchar2(21) -- 出单日期
    ,install_dt varchar2(21) -- 安装日期
    ,hsm varchar2(48) -- 密钥
    ,dealwith varchar2(2) -- 操作
    ,processing_code varchar2(3) -- 处理码
    ,processing_dsp varchar2(383) -- 处理说明
    ,finish varchar2(2) -- 完成
    ,id varchar2(12) -- 
    ,term_area varchar2(150) -- 
    ,term_nm varchar2(120) -- 
    ,term_tel varchar2(18) -- 
    ,oper_id varchar2(18) -- 
    ,term_sta varchar2(2) -- 
    ,create_date varchar2(21) -- 
    ,rec_upd_ts varchar2(21) -- 
    ,upd_oper varchar2(18) -- 
    ,out_mcht_no varchar2(23) -- 
    ,out_term_cd varchar2(12) -- 
    ,mchtserial varchar2(12) -- 商户序号
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
grant select on ${iol_schema}.mrms_tbl_direct_term_inf to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_direct_term_inf to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_direct_term_inf to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_direct_term_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_direct_term_inf is '直联终端信息表';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.term_cd is '编号';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.term_sn is '机身号';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.mcht_no is '商户编号';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.term_type is '型号id';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.use is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.status is '状态';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.comments is '备注';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.recover is '回收';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.order_dt is '出单日期';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.install_dt is '安装日期';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.hsm is '密钥';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.dealwith is '操作';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.processing_code is '处理码';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.processing_dsp is '处理说明';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.finish is '完成';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.id is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.term_area is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.term_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.term_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.oper_id is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.term_sta is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.create_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.rec_upd_ts is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.upd_oper is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.out_mcht_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.out_term_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.mchtserial is '商户序号';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf.etl_timestamp is 'ETL处理时间戳';
