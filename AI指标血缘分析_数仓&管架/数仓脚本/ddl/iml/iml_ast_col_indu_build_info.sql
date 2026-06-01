/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_indu_build_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_indu_build_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_indu_build_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_indu_build_info(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,house_used_flg varchar2(30) -- 一手二手标志
    ,two_in_one_flg varchar2(30) -- 两证合一标志
    ,rel_esat_wat_id varchar2(1000) -- 不动产证号
    ,dev_mode_cd varchar2(30) -- 开发模式代码
    ,all_mtg_flg varchar2(30) -- 全部抵押标志
    ,bs_cont_id varchar2(60) -- 买卖合同编号
    ,buy_dt date -- 购房日期
    ,buy_amt number(30,2) -- 购房金额
    ,arch_area number(30,2) -- 建筑面积
    ,usbl_area number(30,2) -- 实用面积
    ,build_year varchar2(90) -- 建成年份
    ,build_age number(30,2) -- 楼龄
    ,stru_type_cd varchar2(30) -- 结构类型代码
    ,local_prov_cd varchar2(60) -- 所在省代码
    ,local_city_cd varchar2(60) -- 所在市代码
    ,local_rg_cd varchar2(60) -- 所在区代码
    ,street_name varchar2(150) -- 街道名称
    ,dplat_num varchar2(250) -- 门牌号码
    ,rel_esat_wat_rgst_addr varchar2(375) -- 不动产权证登记地址
    ,floor_cnt varchar2(90) -- 楼层数
    ,tot_floor_cnt number(10) -- 总楼层数
    ,status_cd varchar2(30) -- 状态代码
    ,prop_tenor number(30,2) -- 产权期限
    ,land_use_right_id varchar2(375) -- 土地证号
    ,land_char_cd varchar2(30) -- 土地所有权性质代码
    ,land_get_way_cd varchar2(30) -- 土地取得方式代码
    ,land_use_right_begin_dt date -- 土地使用权起始日期
    ,land_use_right_exp_dt date -- 土地使用权到期日期
    ,land_use_right_years number(30,2) -- 土地使用权年限
    ,land_usage_cd varchar2(30) -- 土地用途代码
    ,other_prop_cert_flg varchar2(30) -- 已有他项权证标志
    ,other_comnt varchar2(4000) -- 其他说明
    ,rent_flg varchar2(30) -- 出租标志
    ,tentry_name varchar2(500) -- 承租人名称
    ,rent_begin_dt date -- 出租起始日期
    ,rent_exp_dt date -- 出租到期日期
    ,rent_situ_comnt varchar2(500) -- 出租情况说明
    ,curr_cd varchar2(30) -- 币种代码
    ,rent_anl_inco number(30,2) -- 租赁年收入
    ,house_cmplt_flg varchar2(30) -- 房屋竣工标志
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
grant select on ${iml_schema}.ast_col_indu_build_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_indu_build_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_indu_build_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_indu_build_info is '押品工业用房信息';
comment on column ${iml_schema}.ast_col_indu_build_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_indu_build_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_indu_build_info.house_used_flg is '一手二手标志';
comment on column ${iml_schema}.ast_col_indu_build_info.two_in_one_flg is '两证合一标志';
comment on column ${iml_schema}.ast_col_indu_build_info.rel_esat_wat_id is '不动产证号';
comment on column ${iml_schema}.ast_col_indu_build_info.dev_mode_cd is '开发模式代码';
comment on column ${iml_schema}.ast_col_indu_build_info.all_mtg_flg is '全部抵押标志';
comment on column ${iml_schema}.ast_col_indu_build_info.bs_cont_id is '买卖合同编号';
comment on column ${iml_schema}.ast_col_indu_build_info.buy_dt is '购房日期';
comment on column ${iml_schema}.ast_col_indu_build_info.buy_amt is '购房金额';
comment on column ${iml_schema}.ast_col_indu_build_info.arch_area is '建筑面积';
comment on column ${iml_schema}.ast_col_indu_build_info.usbl_area is '实用面积';
comment on column ${iml_schema}.ast_col_indu_build_info.build_year is '建成年份';
comment on column ${iml_schema}.ast_col_indu_build_info.build_age is '楼龄';
comment on column ${iml_schema}.ast_col_indu_build_info.stru_type_cd is '结构类型代码';
comment on column ${iml_schema}.ast_col_indu_build_info.local_prov_cd is '所在省代码';
comment on column ${iml_schema}.ast_col_indu_build_info.local_city_cd is '所在市代码';
comment on column ${iml_schema}.ast_col_indu_build_info.local_rg_cd is '所在区代码';
comment on column ${iml_schema}.ast_col_indu_build_info.street_name is '街道名称';
comment on column ${iml_schema}.ast_col_indu_build_info.dplat_num is '门牌号码';
comment on column ${iml_schema}.ast_col_indu_build_info.rel_esat_wat_rgst_addr is '不动产权证登记地址';
comment on column ${iml_schema}.ast_col_indu_build_info.floor_cnt is '楼层数';
comment on column ${iml_schema}.ast_col_indu_build_info.tot_floor_cnt is '总楼层数';
comment on column ${iml_schema}.ast_col_indu_build_info.status_cd is '状态代码';
comment on column ${iml_schema}.ast_col_indu_build_info.prop_tenor is '产权期限';
comment on column ${iml_schema}.ast_col_indu_build_info.land_use_right_id is '土地证号';
comment on column ${iml_schema}.ast_col_indu_build_info.land_char_cd is '土地所有权性质代码';
comment on column ${iml_schema}.ast_col_indu_build_info.land_get_way_cd is '土地取得方式代码';
comment on column ${iml_schema}.ast_col_indu_build_info.land_use_right_begin_dt is '土地使用权起始日期';
comment on column ${iml_schema}.ast_col_indu_build_info.land_use_right_exp_dt is '土地使用权到期日期';
comment on column ${iml_schema}.ast_col_indu_build_info.land_use_right_years is '土地使用权年限';
comment on column ${iml_schema}.ast_col_indu_build_info.land_usage_cd is '土地用途代码';
comment on column ${iml_schema}.ast_col_indu_build_info.other_prop_cert_flg is '已有他项权证标志';
comment on column ${iml_schema}.ast_col_indu_build_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_indu_build_info.rent_flg is '出租标志';
comment on column ${iml_schema}.ast_col_indu_build_info.tentry_name is '承租人名称';
comment on column ${iml_schema}.ast_col_indu_build_info.rent_begin_dt is '出租起始日期';
comment on column ${iml_schema}.ast_col_indu_build_info.rent_exp_dt is '出租到期日期';
comment on column ${iml_schema}.ast_col_indu_build_info.rent_situ_comnt is '出租情况说明';
comment on column ${iml_schema}.ast_col_indu_build_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_indu_build_info.rent_anl_inco is '租赁年收入';
comment on column ${iml_schema}.ast_col_indu_build_info.house_cmplt_flg is '房屋竣工标志';
comment on column ${iml_schema}.ast_col_indu_build_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_indu_build_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_indu_build_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_indu_build_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_indu_build_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_indu_build_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_indu_build_info.etl_timestamp is 'ETL处理时间戳';
