/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_cnstring_proj_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_cnstring_proj_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_cnstring_proj_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_cnstring_proj_info(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,rel_esat_wat_id varchar2(900) -- 不动产证号
    ,land_char_cd varchar2(30) -- 土地所有权性质代码
    ,land_get_way_cd varchar2(30) -- 土地取得方式代码
    ,land_use_right_begin_dt date -- 土地使用权起始日期
    ,land_use_right_exp_dt date -- 土地使用权到期日期
    ,land_use_right_years number(30,2) -- 土地使用权年限
    ,land_area number(30,2) -- 土地面积
    ,land_tranf_fee_amt number(30,2) -- 土地出让金金额
    ,land_tranf_fee_dlvy_flg varchar2(10) -- 土地出让金交付标志
    ,attach_tranf_fee_amt number(30,2) -- 应补出让金金额
    ,land_usage_cd varchar2(30) -- 土地用途代码
    ,proj_proj_name varchar2(150) -- 工程项目名称
    ,cnstr_land_use_permit_id varchar2(150) -- 建设用地规划许可证号
    ,cnstr_proj_plan_permit_id varchar2(150) -- 建设工程规划许可证号
    ,proj_cnstr_lics_id varchar2(150) -- 建设工程施工许可证号
    ,start_work_dt date -- 开工日期
    ,expect_cmplt_dt date -- 预计竣工日期
    ,proj_expect_tot_cost number(30,2) -- 工程预计总造价
    ,arch_area number(30,2) -- 建筑面积
    ,tot_floor_cnt number(10) -- 总楼层数
    ,rent_flg varchar2(10) -- 出租标志
    ,local_prov_cd varchar2(60) -- 所在省代码
    ,local_city_cd varchar2(60) -- 所在市代码
    ,local_rg_cd varchar2(60) -- 所在区代码
    ,street_name varchar2(150) -- 街道名称
    ,dplat_id varchar2(250) -- 门牌编号
    ,phys_addr varchar2(500) -- 物理地址
    ,other_comnt varchar2(4000) -- 其他说明
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
grant select on ${iml_schema}.ast_col_cnstring_proj_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_cnstring_proj_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_cnstring_proj_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_cnstring_proj_info is '押品在建工程信息';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.rel_esat_wat_id is '不动产证号';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.land_char_cd is '土地所有权性质代码';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.land_get_way_cd is '土地取得方式代码';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.land_use_right_begin_dt is '土地使用权起始日期';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.land_use_right_exp_dt is '土地使用权到期日期';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.land_use_right_years is '土地使用权年限';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.land_area is '土地面积';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.land_tranf_fee_amt is '土地出让金金额';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.land_tranf_fee_dlvy_flg is '土地出让金交付标志';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.attach_tranf_fee_amt is '应补出让金金额';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.land_usage_cd is '土地用途代码';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.proj_proj_name is '工程项目名称';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.cnstr_land_use_permit_id is '建设用地规划许可证号';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.cnstr_proj_plan_permit_id is '建设工程规划许可证号';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.proj_cnstr_lics_id is '建设工程施工许可证号';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.start_work_dt is '开工日期';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.expect_cmplt_dt is '预计竣工日期';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.proj_expect_tot_cost is '工程预计总造价';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.arch_area is '建筑面积';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.tot_floor_cnt is '总楼层数';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.rent_flg is '出租标志';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.local_prov_cd is '所在省代码';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.local_city_cd is '所在市代码';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.local_rg_cd is '所在区代码';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.street_name is '街道名称';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.dplat_id is '门牌编号';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.phys_addr is '物理地址';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.rent_anl_inco is '租赁年收入';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.house_cmplt_flg is '房屋竣工标志';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_cnstring_proj_info.etl_timestamp is 'ETL处理时间戳';
