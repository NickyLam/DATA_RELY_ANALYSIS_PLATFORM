/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl prd_liab_prod_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.prd_liab_prod_info
whenever sqlerror continue none;
drop table ${idl_schema}.prd_liab_prod_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.prd_liab_prod_info(
    etl_dt date -- 数据日期   
    ,lp_id varchar2(60) -- 法人编号   
    ,prod_id varchar2(60) -- 产品编号   
    ,src_prod_id varchar2(100) -- 源产品编号   
    ,prod_descb varchar2(100) -- 产品描述   
    ,prod_intnal_id varchar2(60) -- 产品内部编号   
    ,prod_effect_dt date -- 产品生效日期   
    ,prod_invalid_dt date -- 产品失效日期   
    ,prod_cate_cd varchar2(10) -- 产品类别代码   
    ,prod_belong_obj_cd varchar2(10) -- 产品所属对象代码   
    ,prod_cls_cd_2 varchar2(10) -- 产品分类代码2   
    ,prod_cls_cd_5 varchar2(10) -- 产品分类代码5   
    ,dep_kind_cd varchar2(10) -- 存款种类代码   
    ,accting_type_cd varchar2(10) -- 会计核算类型代码   
    ,prod_modal_tran_flg varchar2(10) -- 产品形态转移标志   
    ,check_entry_flg varchar2(10) -- 对账标志   
    ,acct_vrfction_flg varchar2(10) -- 账户核查标志   
    ,bal_gl_sync_flg varchar2(10) -- 余额总账同步标志   
    ,auto_precon_draw_flg varchar2(10) -- 自动预约取款标志   
    ,open_acct_lmt_flg varchar2(10) -- 开户限制标志   
    ,open_acct_rela_flg varchar2(10) -- 开户关联标志   
    ,zero_bal_flg varchar2(10) -- 零余额标志   
    ,redt_flg varchar2(10) -- 转存标志   
    ,margin_dep_flg varchar2(10) -- 保证金存款标志   
    ,cfm_open_acct_exp_day_flg varchar2(10) -- 确认开户到期日标志   
    ,od_flg varchar2(10) -- 透支标志   
    ,org_ctrl_flg varchar2(10) -- 机构控制标志   
    ,emply_prod_flg varchar2(10) -- 员工产品标志   
    ,deriv_prod_flg varchar2(10) -- 衍生产品标志   
    ,prod_charge_evt_way_cd varchar2(10) -- 产品收费事件方式代码   
    ,prod_status_cd varchar2(10) -- 产品状态代码   
    ,curr_type_cd varchar2(10) -- 货币类型代码   
    ,spec_acct_num_rule_flg varchar2(10) -- 指定账号规则标志   
    ,matn_teller_id varchar2(60) -- 维护柜员编号   
    ,matn_org_id varchar2(60) -- 维护机构编号   
    ,matn_dt date -- 维护日期   
    ,matn_tm varchar2(10) -- 维护时间   
    ,tm_stamp timestamp -- 时间戳   
    ,rec_status_cd varchar2(10) -- 记录状态代码   
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
grant select on ${idl_schema}.prd_liab_prod_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.prd_liab_prod_info is '负债产品信息';
comment on column ${idl_schema}.prd_liab_prod_info.etl_dt is '数据日期';
comment on column ${idl_schema}.prd_liab_prod_info.lp_id is '法人编号';
comment on column ${idl_schema}.prd_liab_prod_info.prod_id is '产品编号';
comment on column ${idl_schema}.prd_liab_prod_info.src_prod_id is '源产品编号';
comment on column ${idl_schema}.prd_liab_prod_info.prod_descb is '产品描述';
comment on column ${idl_schema}.prd_liab_prod_info.prod_intnal_id is '产品内部编号';
comment on column ${idl_schema}.prd_liab_prod_info.prod_effect_dt is '产品生效日期';
comment on column ${idl_schema}.prd_liab_prod_info.prod_invalid_dt is '产品失效日期';
comment on column ${idl_schema}.prd_liab_prod_info.prod_cate_cd is '产品类别代码';
comment on column ${idl_schema}.prd_liab_prod_info.prod_belong_obj_cd is '产品所属对象代码';
comment on column ${idl_schema}.prd_liab_prod_info.prod_cls_cd_2 is '产品分类代码2';
comment on column ${idl_schema}.prd_liab_prod_info.prod_cls_cd_5 is '产品分类代码5';
comment on column ${idl_schema}.prd_liab_prod_info.dep_kind_cd is '存款种类代码';
comment on column ${idl_schema}.prd_liab_prod_info.accting_type_cd is '会计核算类型代码';
comment on column ${idl_schema}.prd_liab_prod_info.prod_modal_tran_flg is '产品形态转移标志';
comment on column ${idl_schema}.prd_liab_prod_info.check_entry_flg is '对账标志';
comment on column ${idl_schema}.prd_liab_prod_info.acct_vrfction_flg is '账户核查标志';
comment on column ${idl_schema}.prd_liab_prod_info.bal_gl_sync_flg is '余额总账同步标志';
comment on column ${idl_schema}.prd_liab_prod_info.auto_precon_draw_flg is '自动预约取款标志';
comment on column ${idl_schema}.prd_liab_prod_info.open_acct_lmt_flg is '开户限制标志';
comment on column ${idl_schema}.prd_liab_prod_info.open_acct_rela_flg is '开户关联标志';
comment on column ${idl_schema}.prd_liab_prod_info.zero_bal_flg is '零余额标志';
comment on column ${idl_schema}.prd_liab_prod_info.redt_flg is '转存标志';
comment on column ${idl_schema}.prd_liab_prod_info.margin_dep_flg is '保证金存款标志';
comment on column ${idl_schema}.prd_liab_prod_info.cfm_open_acct_exp_day_flg is '确认开户到期日标志';
comment on column ${idl_schema}.prd_liab_prod_info.od_flg is '透支标志';
comment on column ${idl_schema}.prd_liab_prod_info.org_ctrl_flg is '机构控制标志';
comment on column ${idl_schema}.prd_liab_prod_info.emply_prod_flg is '员工产品标志';
comment on column ${idl_schema}.prd_liab_prod_info.deriv_prod_flg is '衍生产品标志';
comment on column ${idl_schema}.prd_liab_prod_info.prod_charge_evt_way_cd is '产品收费事件方式代码';
comment on column ${idl_schema}.prd_liab_prod_info.prod_status_cd is '产品状态代码';
comment on column ${idl_schema}.prd_liab_prod_info.curr_type_cd is '货币类型代码';
comment on column ${idl_schema}.prd_liab_prod_info.spec_acct_num_rule_flg is '指定账号规则标志';
comment on column ${idl_schema}.prd_liab_prod_info.matn_teller_id is '维护柜员编号';
comment on column ${idl_schema}.prd_liab_prod_info.matn_org_id is '维护机构编号';
comment on column ${idl_schema}.prd_liab_prod_info.matn_dt is '维护日期';
comment on column ${idl_schema}.prd_liab_prod_info.matn_tm is '维护时间';
comment on column ${idl_schema}.prd_liab_prod_info.tm_stamp is '时间戳';
comment on column ${idl_schema}.prd_liab_prod_info.rec_status_cd is '记录状态代码';
comment on column ${idl_schema}.prd_liab_prod_info.create_dt is '创建日期';
comment on column ${idl_schema}.prd_liab_prod_info.update_dt is '更新日期';
comment on column ${idl_schema}.prd_liab_prod_info.id_mark is '删除标识';