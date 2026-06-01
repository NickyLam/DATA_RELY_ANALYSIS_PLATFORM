/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ast_col_recvbl_rent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ast_col_recvbl_rent_info
whenever sqlerror continue none;
drop table ${idl_schema}.ast_col_recvbl_rent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ast_col_recvbl_rent_info(
    etl_dt date -- 数据日期   
    ,asset_id varchar2(60) -- 资产编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,rent_cnt number(10) -- 年收租次数   
    ,rent_type_cd varchar2(30) -- 租金类型代码   
    ,everytime_fix_rent_amt number(30,2) -- 每次固定租金金额   
    ,float_rent_amt_comnt varchar2(250) -- 浮动租金金额说明   
    ,lease_effect_dt date -- 租约生效日期   
    ,lease_invalid_dt date -- 租约失效日期   
    ,advise_acct_recvbl_flg varchar2(10) -- 通知应收账款义务人标志   
    ,cred_rht_prod_flg varchar2(10) -- 债权产生标志   
    ,other_comnt varchar2(4000) -- 其他说明   
    ,rela_flg varchar2(10) -- 关系标志   
    ,curr_cd varchar2(30) -- 币种代码   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ast_col_recvbl_rent_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.ast_col_recvbl_rent_info is '押品应收租金信息';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.etl_dt is '数据日期';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.asset_id is '资产编号';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.lp_id is '法人编号';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.rent_cnt is '年收租次数';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.rent_type_cd is '租金类型代码';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.everytime_fix_rent_amt is '每次固定租金金额';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.float_rent_amt_comnt is '浮动租金金额说明';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.lease_effect_dt is '租约生效日期';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.lease_invalid_dt is '租约失效日期';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.advise_acct_recvbl_flg is '通知应收账款义务人标志';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.cred_rht_prod_flg is '债权产生标志';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.other_comnt is '其他说明';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.rela_flg is '关系标志';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.curr_cd is '币种代码';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.create_dt is '创建日期';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.update_dt is '更新日期';
comment on column ${idl_schema}.ast_col_recvbl_rent_info.id_mark is '删除标识';