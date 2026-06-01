/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_asset_pool_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_asset_pool_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_asset_pool_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_asset_pool_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,asset_pool_id varchar2(100) -- 资产池编号
    ,asset_pool_name varchar2(750) -- 资产池名称
    ,parent_asset_pool_id varchar2(100) -- 父资产池编号
    ,asset_pool_type_cd varchar2(30) -- 资产池类型代码
    ,asset_pool_char_cd varchar2(30) -- 资产池性质代码
    ,asset_pool_status_cd varchar2(30) -- 资产池状态代码
    ,pkg_flg varchar2(10) -- 封包标志
    ,pkg_dt date -- 封包日期
    ,tran_dt date -- 转让日期
    ,recvbl_dt date -- 收款日期
    ,pkg_day_asset_qtty number(30) -- 封包日资产数量
    ,pkg_day_asset_size number(30,8) -- 封包日资产规模
    ,tran_day_pric number(30,8) -- 转让日本金
    ,recvbl_day_pric number(30,8) -- 收款日本金
    ,actl_recvbl_amt number(30,8) -- 实际收款金额
    ,asset_pool_size number(30,8) -- 资产池规模
    ,unpkg_dt date -- 解包日期
    ,end_type_cd varchar2(30) -- 终结类型代码
    ,final_dt date -- 终结日期
    ,add_pkg_asset_qtty number(30) -- 新增封包资产数量
    ,curr_cd varchar2(30) -- 币种代码
    ,rgstrat_id varchar2(100) -- 登记人编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_tm timestamp -- 登记时间
    ,asset_pool_acm_asset_size number(30,2) -- 资产池累计资产规模
    ,asset_pool_acm_asset_qtty number(30) -- 资产池累计资产数量
    ,recvbl_acct_name varchar2(750) -- 收款账户名称
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_belong_org_id varchar2(100) -- 收款账户所属机构编号
    ,return_coll_acct_name varchar2(750) -- 回款归集账户名称
    ,return_coll_acct_num varchar2(100) -- 回款归集账户账号
    ,coll_acct_belong_org_id varchar2(100) -- 回款归集账户所属机构编号
    ,pkg_weight_surp_tenor number(30) -- 封包时加权剩余期限
    ,pkg_weight_avg_int_rat number(18,8) -- 封包时加权平均利率
    ,fee_provi_dt date -- 费用计提日期
    ,asset_pool_realtm_size number(30,2) -- 资产池实时规模
    ,non_asset_flg varchar2(10) -- 不良资产标志
    ,update_tm timestamp -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_asset_pool_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_asset_pool_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_asset_pool_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_asset_pool_info_h is '资产池信息历史';
comment on column ${iml_schema}.agt_asset_pool_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_asset_pool_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_asset_pool_info_h.asset_pool_id is '资产池编号';
comment on column ${iml_schema}.agt_asset_pool_info_h.asset_pool_name is '资产池名称';
comment on column ${iml_schema}.agt_asset_pool_info_h.parent_asset_pool_id is '父资产池编号';
comment on column ${iml_schema}.agt_asset_pool_info_h.asset_pool_type_cd is '资产池类型代码';
comment on column ${iml_schema}.agt_asset_pool_info_h.asset_pool_char_cd is '资产池性质代码';
comment on column ${iml_schema}.agt_asset_pool_info_h.asset_pool_status_cd is '资产池状态代码';
comment on column ${iml_schema}.agt_asset_pool_info_h.pkg_flg is '封包标志';
comment on column ${iml_schema}.agt_asset_pool_info_h.pkg_dt is '封包日期';
comment on column ${iml_schema}.agt_asset_pool_info_h.tran_dt is '转让日期';
comment on column ${iml_schema}.agt_asset_pool_info_h.recvbl_dt is '收款日期';
comment on column ${iml_schema}.agt_asset_pool_info_h.pkg_day_asset_qtty is '封包日资产数量';
comment on column ${iml_schema}.agt_asset_pool_info_h.pkg_day_asset_size is '封包日资产规模';
comment on column ${iml_schema}.agt_asset_pool_info_h.tran_day_pric is '转让日本金';
comment on column ${iml_schema}.agt_asset_pool_info_h.recvbl_day_pric is '收款日本金';
comment on column ${iml_schema}.agt_asset_pool_info_h.actl_recvbl_amt is '实际收款金额';
comment on column ${iml_schema}.agt_asset_pool_info_h.asset_pool_size is '资产池规模';
comment on column ${iml_schema}.agt_asset_pool_info_h.unpkg_dt is '解包日期';
comment on column ${iml_schema}.agt_asset_pool_info_h.end_type_cd is '终结类型代码';
comment on column ${iml_schema}.agt_asset_pool_info_h.final_dt is '终结日期';
comment on column ${iml_schema}.agt_asset_pool_info_h.add_pkg_asset_qtty is '新增封包资产数量';
comment on column ${iml_schema}.agt_asset_pool_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_asset_pool_info_h.rgstrat_id is '登记人编号';
comment on column ${iml_schema}.agt_asset_pool_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_asset_pool_info_h.rgst_tm is '登记时间';
comment on column ${iml_schema}.agt_asset_pool_info_h.asset_pool_acm_asset_size is '资产池累计资产规模';
comment on column ${iml_schema}.agt_asset_pool_info_h.asset_pool_acm_asset_qtty is '资产池累计资产数量';
comment on column ${iml_schema}.agt_asset_pool_info_h.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_asset_pool_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_asset_pool_info_h.recvbl_acct_belong_org_id is '收款账户所属机构编号';
comment on column ${iml_schema}.agt_asset_pool_info_h.return_coll_acct_name is '回款归集账户名称';
comment on column ${iml_schema}.agt_asset_pool_info_h.return_coll_acct_num is '回款归集账户账号';
comment on column ${iml_schema}.agt_asset_pool_info_h.coll_acct_belong_org_id is '回款归集账户所属机构编号';
comment on column ${iml_schema}.agt_asset_pool_info_h.pkg_weight_surp_tenor is '封包时加权剩余期限';
comment on column ${iml_schema}.agt_asset_pool_info_h.pkg_weight_avg_int_rat is '封包时加权平均利率';
comment on column ${iml_schema}.agt_asset_pool_info_h.fee_provi_dt is '费用计提日期';
comment on column ${iml_schema}.agt_asset_pool_info_h.asset_pool_realtm_size is '资产池实时规模';
comment on column ${iml_schema}.agt_asset_pool_info_h.non_asset_flg is '不良资产标志';
comment on column ${iml_schema}.agt_asset_pool_info_h.update_tm is '更新时间';
comment on column ${iml_schema}.agt_asset_pool_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_asset_pool_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_asset_pool_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_asset_pool_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_asset_pool_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_asset_pool_info_h.etl_timestamp is 'ETL处理时间戳';
