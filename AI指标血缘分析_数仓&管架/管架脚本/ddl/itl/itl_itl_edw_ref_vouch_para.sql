/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ref_vouch_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ref_vouch_para
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ref_vouch_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ref_vouch_para(
    vouch_kind_cd varchar2(10) -- 凭证种类代码
    ,vouch_name varchar2(100) -- 凭证名称
    ,vouch_abbr varchar2(100) -- 凭证简称
    ,vouch_char_cd varchar2(10) -- 凭证性质代码
    ,vouch_form_cd varchar2(10) -- 凭证形式代码
    ,vouch_id_length number(10) -- 凭证编号长度
    ,vouch_batch_no_length number(10) -- 凭证批号长度
    ,curr_batch_no varchar2(60) -- 当前批号
    ,each_this_vouch_qtty number(10) -- 每本凭证数量
    ,tran_vouch_type_cd varchar2(10) -- 交易凭证类型代码
    ,ghb_vouch_flg varchar2(10) -- 本行凭证标志
    ,invtry_mgmt_flg varchar2(10) -- 库存管理标志
    ,sell_permit_flg varchar2(10) -- 出售许可标志
    ,buy_org_ctrl_cd varchar2(10) -- 购入机构控制代码
    ,porf_flg varchar2(10) -- 有价证券标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ref_vouch_para to ${icl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ref_vouch_para is '凭证参数表';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.vouch_kind_cd is '凭证种类代码';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.vouch_name is '凭证名称';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.vouch_abbr is '凭证简称';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.vouch_char_cd is '凭证性质代码';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.vouch_form_cd is '凭证形式代码';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.vouch_id_length is '凭证编号长度';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.vouch_batch_no_length is '凭证批号长度';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.curr_batch_no is '当前批号';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.each_this_vouch_qtty is '每本凭证数量';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.tran_vouch_type_cd is '交易凭证类型代码';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.ghb_vouch_flg is '本行凭证标志';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.invtry_mgmt_flg is '库存管理标志';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.sell_permit_flg is '出售许可标志';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.buy_org_ctrl_cd is '购入机构控制代码';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.porf_flg is '有价证券标志';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ref_vouch_para.etl_timestamp is 'ETL处理时间戳';
