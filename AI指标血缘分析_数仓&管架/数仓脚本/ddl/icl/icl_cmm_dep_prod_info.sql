/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_dep_prod_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_dep_prod_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_dep_prod_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_prod_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,intnal_prod_id varchar2(60) -- 内部产品编号
    ,accting_id varchar2(10) -- 会计核算编号
    ,prod_cate_cd varchar2(10) -- 产品类别代码
    ,pd_prod_cate_cd varchar2(30) -- 期次产品类别代码
    ,sell_obj_cd varchar2(3000) -- 销售对象代码
    ,dep_kind_cd varchar2(10) -- 存款种类代码
    ,charge_evt_way_cd varchar2(10) -- 收费事件方式代码
    ,supt_buy_way_cd varchar2(10) -- 支持购买方式代码
    ,status_cd varchar2(10) -- 状态代码
    ,pd_status_cd varchar2(30) -- 期次状态代码
    ,pd_tenor_type_cd varchar2(30) -- 期次期限类型代码
    ,curr_type_cd varchar2(3000) -- 货币类型代码
    ,prod_modal_tran_flg varchar2(10) -- 产品形态转移标志
    ,gl_sync_flg varchar2(10) -- 总账同步标志
    ,precon_draw_flg varchar2(10) -- 预约取款标志
    ,open_lmt_flg varchar2(10) -- 开户限制标志
    ,rela_vouch_flg varchar2(10) -- 关联凭证标志
    ,allow_zero_bal_flg varchar2(10) -- 允许零余额标志
    ,redt_flg varchar2(10) -- 转存标志
    ,margin_dep_flg varchar2(10) -- 保证金存款标志
    ,allow_od_flg varchar2(10) -- 允许透支标志
    ,emply_prod_flg varchar2(10) -- 员工产品标志
    ,deriv_prod_flg varchar2(10) -- 衍生产品标志
    ,mpr_flg varchar2(10) -- 利随本清标志
    ,allow_redem_flg varchar2(10) -- 允许赎回标志
    ,allow_tran_flg varchar2(10) -- 允许转让标志
    ,allow_spec_col_int_flg varchar2(10) -- 允许指定收息标志
    ,allow_inpwn_flg varchar2(10) -- 允许质押标志
    ,renew_dep_way_cd varchar2(10) -- 续存方式代码
    ,allow_multi_subscr_flg varchar2(10) -- 允许多次认购标志
    ,advd_draw_flg varchar2(10) -- 可提前支取标志
    ,unexp_draw_way_cd varchar2(10) -- 提前支取方式代码
    ,allow_tran_wdraw_flg varchar2(10) -- 允许转帐支取标志
    ,allow_wdraw_cnt number(10) -- 允许支取次数
    ,allow_wdraw_max_amt number(30,2) -- 允许支取最大金额
    ,base_rat_id varchar2(60) -- 基准利率编号
    ,int_rat_file_type_cd varchar2(10) -- 利率靠档类型代码
    ,base_rat number(18,8) -- 基准利率
    ,int_rat_flo_val number(18,8) -- 利率浮动值
    ,pay_int_freq varchar2(10) -- 付息频率
    ,spread_int_rat number(18,8) -- 推广利率
    ,redem_int_rat number(18,8) -- 赎回利率
    ,matn_teller_id varchar2(60) -- 维护柜员编号
    ,matn_org_id varchar2(500) -- 维护机构编号
	,dep_tenor number(10) -- 存款期限
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,stat_prod_subscr_lmt_flg varchar2(10) -- 统计产品认购额度标志
    ,value_way_cd varchar2(10) -- 起息方式代码
    ,bus_mgmt_cls_cd varchar2(500) -- 业务管理分类代码
    ,prod_issue_tot_uplmi number(30,2) -- 产品发行总额上限
    ,prod_issue_tot_lolmi number(30,2) -- 产品发行总额下限
    ,sell_begin_dt_tm timestamp(6) -- 销售起始日期时间
    ,sell_termnt_dt_tm timestamp(6) -- 销售终止日期时间
    ,apot_redem_dt varchar2(60) -- 约定赎回日期
    ,redem_int_rat_type varchar2(60) -- 赎回利率类型
    ,init_amt number(30,2) -- 起存金额
    ,incremt_amt number(30,2) -- 增量金额
    ,min_retnd_amt number(30,2) -- 最小留存金额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_dep_prod_info to ${idl_schema};
grant select on ${icl_schema}.cmm_dep_prod_info to ${iel_schema};
grant select on ${icl_schema}.cmm_dep_prod_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_dep_prod_info is '存款产品信息';
comment on column ${icl_schema}.cmm_dep_prod_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_dep_prod_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_dep_prod_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_dep_prod_info.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_dep_prod_info.intnal_prod_id is '内部产品编号';
comment on column ${icl_schema}.cmm_dep_prod_info.accting_id is '会计核算编号';
comment on column ${icl_schema}.cmm_dep_prod_info.prod_cate_cd is '产品类别代码';
comment on column ${icl_schema}.cmm_dep_prod_info.pd_prod_cate_cd is '期次产品类别代码';
comment on column ${icl_schema}.cmm_dep_prod_info.sell_obj_cd is '销售对象代码';
comment on column ${icl_schema}.cmm_dep_prod_info.dep_kind_cd is '存款种类代码';
comment on column ${icl_schema}.cmm_dep_prod_info.charge_evt_way_cd is '收费事件方式代码';
comment on column ${icl_schema}.cmm_dep_prod_info.supt_buy_way_cd is '支持购买方式代码';
comment on column ${icl_schema}.cmm_dep_prod_info.status_cd is '状态代码';
comment on column ${icl_schema}.cmm_dep_prod_info.pd_status_cd is '期次状态代码';
comment on column ${icl_schema}.cmm_dep_prod_info.pd_tenor_type_cd is '期次期限类型代码';
comment on column ${icl_schema}.cmm_dep_prod_info.curr_type_cd is '货币类型代码';
comment on column ${icl_schema}.cmm_dep_prod_info.prod_modal_tran_flg is '产品形态转移标志';
comment on column ${icl_schema}.cmm_dep_prod_info.gl_sync_flg is '总账同步标志';
comment on column ${icl_schema}.cmm_dep_prod_info.precon_draw_flg is '预约取款标志';
comment on column ${icl_schema}.cmm_dep_prod_info.open_lmt_flg is '开户限制标志';
comment on column ${icl_schema}.cmm_dep_prod_info.rela_vouch_flg is '关联凭证标志';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_zero_bal_flg is '允许零余额标志';
comment on column ${icl_schema}.cmm_dep_prod_info.redt_flg is '转存标志';
comment on column ${icl_schema}.cmm_dep_prod_info.margin_dep_flg is '保证金存款标志';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_od_flg is '允许透支标志';
comment on column ${icl_schema}.cmm_dep_prod_info.emply_prod_flg is '员工产品标志';
comment on column ${icl_schema}.cmm_dep_prod_info.deriv_prod_flg is '衍生产品标志';
comment on column ${icl_schema}.cmm_dep_prod_info.mpr_flg is '利随本清标志';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_redem_flg is '允许赎回标志';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_tran_flg is '允许转让标志';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_spec_col_int_flg is '允许指定收息标志';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_inpwn_flg is '允许质押标志';
comment on column ${icl_schema}.cmm_dep_prod_info.renew_dep_way_cd is '续存方式代码';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_multi_subscr_flg is '允许多次认购标志';
comment on column ${icl_schema}.cmm_dep_prod_info.advd_draw_flg is '可提前支取标志';
comment on column ${icl_schema}.cmm_dep_prod_info.unexp_draw_way_cd is '提前支取方式代码';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_tran_wdraw_flg is '允许转帐支取标志';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_wdraw_cnt is '允许支取次数';
comment on column ${icl_schema}.cmm_dep_prod_info.allow_wdraw_max_amt is '允许支取最大金额';
comment on column ${icl_schema}.cmm_dep_prod_info.base_rat_id is '基准利率编号';
comment on column ${icl_schema}.cmm_dep_prod_info.int_rat_file_type_cd is '利率靠档类型代码';
comment on column ${icl_schema}.cmm_dep_prod_info.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_dep_prod_info.int_rat_flo_val is '利率浮动值';
comment on column ${icl_schema}.cmm_dep_prod_info.pay_int_freq is '付息频率';
comment on column ${icl_schema}.cmm_dep_prod_info.spread_int_rat is '推广利率';
comment on column ${icl_schema}.cmm_dep_prod_info.redem_int_rat is '赎回利率';
comment on column ${icl_schema}.cmm_dep_prod_info.matn_teller_id is '维护柜员编号';
comment on column ${icl_schema}.cmm_dep_prod_info.matn_org_id is '维护机构编号';
comment on column ${icl_schema}.cmm_dep_prod_info.dep_tenor is '存款期限';
comment on column ${icl_schema}.cmm_dep_prod_info.effect_dt is '生效日期';
comment on column ${icl_schema}.cmm_dep_prod_info.invalid_dt is '失效日期';
comment on column ${icl_schema}.cmm_dep_prod_info.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_dep_prod_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_dep_prod_info.stat_prod_subscr_lmt_flg is '统计产品认购额度标志';
comment on column ${icl_schema}.cmm_dep_prod_info.value_way_cd is '起息方式代码';
comment on column ${icl_schema}.cmm_dep_prod_info.bus_mgmt_cls_cd is '业务管理分类代码';
comment on column ${icl_schema}.cmm_dep_prod_info.prod_issue_tot_uplmi is '产品发行总额上限';
comment on column ${icl_schema}.cmm_dep_prod_info.prod_issue_tot_lolmi is '产品发行总额下限';
comment on column ${icl_schema}.cmm_dep_prod_info.sell_begin_dt_tm is '销售起始日期时间';
comment on column ${icl_schema}.cmm_dep_prod_info.sell_termnt_dt_tm is '销售终止日期时间';
comment on column ${icl_schema}.cmm_dep_prod_info.apot_redem_dt is '约定赎回日期';
comment on column ${icl_schema}.cmm_dep_prod_info.redem_int_rat_type is '赎回利率类型';
comment on column ${icl_schema}.cmm_dep_prod_info.init_amt is '起存金额';
comment on column ${icl_schema}.cmm_dep_prod_info.incremt_amt is '增量金额';
comment on column ${icl_schema}.cmm_dep_prod_info.min_retnd_amt is '最小留存金额';
comment on column ${icl_schema}.cmm_dep_prod_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_dep_prod_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_dep_prod_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_dep_prod_info.etl_timestamp is 'ETL处理时间戳';
