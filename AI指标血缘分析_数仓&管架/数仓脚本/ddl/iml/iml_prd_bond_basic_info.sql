/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_bond_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_bond_basic_info
whenever sqlerror continue none;
drop table ${iml_schema}.prd_bond_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_basic_info(
    bond_id varchar2(60) -- 债券编号
    ,lp_id varchar2(60) -- 法人编号
    ,bond_abbr varchar2(375) -- 债券简称
    ,bond_name varchar2(375) -- 债券名称
    ,init_bond_type_cd varchar2(10) -- 原债券类型代码
    ,issuer_name varchar2(150) -- 发行人名称
    ,guartor_name varchar2(300) -- 担保人名称
    ,pric_curr_cd varchar2(10) -- 本金币种代码
    ,int_curr_cd varchar2(10) -- 利息币种代码
    ,issue_dt date -- 债券发行日期
    ,value_dt date -- 债券起息日期
    ,exp_dt date -- 债券到期日期
    ,issue_corp number(22,0) -- 发行单位
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_rat_type_cd varchar2(10) -- 利率类型代码
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,base_rat_id varchar2(60) -- 基准利率编号
    ,float_dir_cd varchar2(10) -- 浮动方向代码
    ,int_rat_float_point number(38,8) -- 利率浮动点数
    ,int_rat_reset_freq varchar2(10) -- 利率重置频率
    ,fir_int_rat_reset_dt date -- 首次利率重置日期
    ,int_accr_freq varchar2(10) -- 计息频率
    ,fir_pay_int_dt date -- 首次付息日期
    ,pay_int_freq varchar2(10) -- 付息频率
    ,comp_int_freq varchar2(10) -- 复利频率
    ,choice_type_cd varchar2(10) -- 选择权类型代码
    ,each_issue_rpp_amt number(30,2) -- 每期还本金额
    ,issue_amt number(30,8) -- 发行金额
    ,issue_int_rat number(18,8) -- 发行利率
    ,issue_price number(30,8) -- 发行价格
    ,list_tran_dt date -- 上市交易日期
    ,market_type_cd varchar2(10) -- 上市交易所代码
    ,inpwn_ratio number(18,6) -- 质押比例
    ,tranbl_flg varchar2(10) -- 可转换标志
    ,convbl_bond_id varchar2(60) -- 可转债编号
    ,discnt_debt_flg varchar2(10) -- 贴现债标志
    ,int_rat_float_uplmi number(18,8) -- 利率浮动上限
    ,int_rat_float_lolmi number(18,8) -- 利率浮动下限
    ,int_rat_reset_way_cd varchar2(10) -- 利率重置方式代码
    ,stop_tran_dt date -- 停止交易日期
    ,guara_type_cd varchar2(10) -- 担保品类型代码
    ,init_tenor number(18,0) -- 原始期限
    ,init_tenor_type_cd varchar2(10) -- 原期限类型代码
    ,acru_int_flg varchar2(10) -- 应计利息标志
    ,bond_type_cd varchar2(10) -- 债券类型代码
    ,remark varchar2(750) -- 备注
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_bond_basic_info to ${icl_schema};
grant select on ${iml_schema}.prd_bond_basic_info to ${idl_schema};
grant select on ${iml_schema}.prd_bond_basic_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_bond_basic_info is '债券基本信息';
comment on column ${iml_schema}.prd_bond_basic_info.bond_id is '债券编号';
comment on column ${iml_schema}.prd_bond_basic_info.lp_id is '法人编号';
comment on column ${iml_schema}.prd_bond_basic_info.bond_abbr is '债券简称';
comment on column ${iml_schema}.prd_bond_basic_info.bond_name is '债券名称';
comment on column ${iml_schema}.prd_bond_basic_info.init_bond_type_cd is '原债券类型代码';
comment on column ${iml_schema}.prd_bond_basic_info.issuer_name is '发行人名称';
comment on column ${iml_schema}.prd_bond_basic_info.guartor_name is '担保人名称';
comment on column ${iml_schema}.prd_bond_basic_info.pric_curr_cd is '本金币种代码';
comment on column ${iml_schema}.prd_bond_basic_info.int_curr_cd is '利息币种代码';
comment on column ${iml_schema}.prd_bond_basic_info.issue_dt is '债券发行日期';
comment on column ${iml_schema}.prd_bond_basic_info.value_dt is '债券起息日期';
comment on column ${iml_schema}.prd_bond_basic_info.exp_dt is '债券到期日期';
comment on column ${iml_schema}.prd_bond_basic_info.issue_corp is '发行单位';
comment on column ${iml_schema}.prd_bond_basic_info.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.prd_bond_basic_info.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.prd_bond_basic_info.fac_val_int_rat is '票面利率';
comment on column ${iml_schema}.prd_bond_basic_info.base_rat_id is '基准利率编号';
comment on column ${iml_schema}.prd_bond_basic_info.float_dir_cd is '浮动方向代码';
comment on column ${iml_schema}.prd_bond_basic_info.int_rat_float_point is '利率浮动点数';
comment on column ${iml_schema}.prd_bond_basic_info.int_rat_reset_freq is '利率重置频率';
comment on column ${iml_schema}.prd_bond_basic_info.fir_int_rat_reset_dt is '首次利率重置日期';
comment on column ${iml_schema}.prd_bond_basic_info.int_accr_freq is '计息频率';
comment on column ${iml_schema}.prd_bond_basic_info.fir_pay_int_dt is '首次付息日期';
comment on column ${iml_schema}.prd_bond_basic_info.pay_int_freq is '付息频率';
comment on column ${iml_schema}.prd_bond_basic_info.comp_int_freq is '复利频率';
comment on column ${iml_schema}.prd_bond_basic_info.choice_type_cd is '选择权类型代码';
comment on column ${iml_schema}.prd_bond_basic_info.each_issue_rpp_amt is '每期还本金额';
comment on column ${iml_schema}.prd_bond_basic_info.issue_amt is '发行金额';
comment on column ${iml_schema}.prd_bond_basic_info.issue_int_rat is '发行利率';
comment on column ${iml_schema}.prd_bond_basic_info.issue_price is '发行价格';
comment on column ${iml_schema}.prd_bond_basic_info.list_tran_dt is '上市交易日期';
comment on column ${iml_schema}.prd_bond_basic_info.market_type_cd is '上市交易所代码';
comment on column ${iml_schema}.prd_bond_basic_info.inpwn_ratio is '质押比例';
comment on column ${iml_schema}.prd_bond_basic_info.tranbl_flg is '可转换标志';
comment on column ${iml_schema}.prd_bond_basic_info.convbl_bond_id is '可转债编号';
comment on column ${iml_schema}.prd_bond_basic_info.discnt_debt_flg is '贴现债标志';
comment on column ${iml_schema}.prd_bond_basic_info.int_rat_float_uplmi is '利率浮动上限';
comment on column ${iml_schema}.prd_bond_basic_info.int_rat_float_lolmi is '利率浮动下限';
comment on column ${iml_schema}.prd_bond_basic_info.int_rat_reset_way_cd is '利率重置方式代码';
comment on column ${iml_schema}.prd_bond_basic_info.stop_tran_dt is '停止交易日期';
comment on column ${iml_schema}.prd_bond_basic_info.guara_type_cd is '担保品类型代码';
comment on column ${iml_schema}.prd_bond_basic_info.init_tenor is '原始期限';
comment on column ${iml_schema}.prd_bond_basic_info.init_tenor_type_cd is '原期限类型代码';
comment on column ${iml_schema}.prd_bond_basic_info.acru_int_flg is '应计利息标志';
comment on column ${iml_schema}.prd_bond_basic_info.bond_type_cd is '债券类型代码';
comment on column ${iml_schema}.prd_bond_basic_info.remark is '备注';
comment on column ${iml_schema}.prd_bond_basic_info.create_dt is '创建日期';
comment on column ${iml_schema}.prd_bond_basic_info.update_dt is '更新日期';
comment on column ${iml_schema}.prd_bond_basic_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_bond_basic_info.id_mark is '增删标志';
comment on column ${iml_schema}.prd_bond_basic_info.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_bond_basic_info.job_cd is '任务编码';
comment on column ${iml_schema}.prd_bond_basic_info.etl_timestamp is 'ETL处理时间戳';
