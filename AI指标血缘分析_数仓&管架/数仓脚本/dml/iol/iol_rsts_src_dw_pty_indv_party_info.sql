/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_src_dw_pty_indv_party_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_src_dw_pty_indv_party_info_ex purge;
alter table ${iol_schema}.rsts_src_dw_pty_indv_party_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_src_dw_pty_indv_party_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_src_dw_pty_indv_party_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_src_dw_pty_indv_party_info where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_src_dw_pty_indv_party_info_ex(
    pty_id -- 客户编号
    ,etl_dt_ora -- 数据日期
    ,open_dt -- 开户日期
    ,open_org_id -- 开户机构编号
    ,open_teller_id -- 开户柜员编号
    ,setup_chn_typ_cd -- 建立渠道类型代码
    ,pty_categ_cd -- 客户类别代码
    ,blng_org_id -- 所属机构编号
    ,blng_pty_mgr_id -- 所属客户经理编号
    ,colse_dt -- 销户日期
    ,colse_org_id -- 销户机构编号
    ,colse_teller_id -- 销户柜员编号
    ,pty_typ_cd -- 客户类型代码
    ,pty_blng_indu_cd -- 客户所属行业代码
    ,pty_loc_cd -- 客户所在地代码
    ,non_resident_flg -- 非居民标志
    ,farmer_flg -- 农户标志
    ,indv_indu_com_acct_flg -- 个体工商户标志
    ,pty_status_cd -- 客户状态代码
    ,legal_name -- 法定名称
    ,cn_fname -- 中文全称
    ,cn_sname -- 中文简称
    ,piny_name -- 拼音名称
    ,en_fname -- 英文全称
    ,en_sname -- 英文简称
    ,birth_dt -- 出生日期
    ,gender_cd -- 性别代码
    ,birth_pla_cd -- 出生地代码
    ,native_place_cd -- 籍贯代码
    ,nation_cd -- 国籍代码
    ,ethnic_cd -- 民族代码
    ,poli_face_cd -- 政治面貌代码
    ,reli_fai_cd -- 宗教信仰代码
    ,marriage_status_cd -- 婚姻状况代码
    ,highest_edu_degree_cd -- 最高学历代码
    ,highest_degree_cd -- 最高学位代码
    ,grad_sch -- 毕业院校
    ,reside_status_cd -- 居住状况代码
    ,join_work_tm -- 参加工作时间
    ,work_corp_name -- 工作单位名称
    ,join_enterprise_dt -- 加入现单位日期
    ,corp_blng_indu_cd -- 单位所属行业代码
    ,corp_prop_cd -- 单位性质代码
    ,unit_addr -- 单位地址
    ,corp_loc_zipcode -- 单位地址邮政编码
    ,profsn_title_cd -- 职称代码
    ,duty_cd -- 职务代码
    ,career_cd -- 职业代码
    ,sala_acct_num -- 工资账户账号
    ,sala_acct_open_bank -- 工资账户开户银行
    ,ghb_emp_flg -- 本行员工标志
    ,emp_id -- 员工编号
    ,ghb_shrholder_flg -- 本行股东标志
    ,auth_mode_cd -- 认证方式代码
    ,safe_rank_cd -- 安全等级代码
    ,invt_risk_pref_cd -- 投资风险偏好代码
    ,risk_ablt_est_org -- 风险能力评估机构
    ,risk_ablt_est_dt -- 风险能力评估日期
    ,raise_cnt -- 供养人数
    ,family_anl_inc -- 家庭年收入
    ,family_mon_income -- 家庭月收入
    ,indv_mon_income -- 个人月收入
    ,indv_year_income -- 个人年收入
    ,car_brand -- 拥有汽车品牌
    ,blkl_pty_flg -- 黑名单客户标志
    ,up_blkl_dt -- 上黑名单日期
    ,up_blkl_rsns -- 上黑名单原因
    ,blkl_src_cd -- 黑名单来源代码
    ,prefr_cont_mode_cd -- 优选联系方式代码
    ,bank_res_tel_num -- 银行预留电话号码
    ,crdt_pty_flg -- 授信客户标志
    ,small_eown_flg -- 小微企业主标志
    ,open_card_typ_cd -- 开卡类型代码
    ,pty_level_cd -- 客户级别代码
    ,real_nm_flg -- 实名标志
    ,co_brand_pty_flg -- 联名客户标志
    ,insd_and_otsd_flg -- 境内外标志
    ,assoc_txn_flg -- 关联交易标志
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    pty_id -- 客户编号
    ,etl_dt_ora -- 数据日期
    ,open_dt -- 开户日期
    ,open_org_id -- 开户机构编号
    ,open_teller_id -- 开户柜员编号
    ,setup_chn_typ_cd -- 建立渠道类型代码
    ,pty_categ_cd -- 客户类别代码
    ,blng_org_id -- 所属机构编号
    ,blng_pty_mgr_id -- 所属客户经理编号
    ,colse_dt -- 销户日期
    ,colse_org_id -- 销户机构编号
    ,colse_teller_id -- 销户柜员编号
    ,pty_typ_cd -- 客户类型代码
    ,pty_blng_indu_cd -- 客户所属行业代码
    ,pty_loc_cd -- 客户所在地代码
    ,non_resident_flg -- 非居民标志
    ,farmer_flg -- 农户标志
    ,indv_indu_com_acct_flg -- 个体工商户标志
    ,pty_status_cd -- 客户状态代码
    ,legal_name -- 法定名称
    ,cn_fname -- 中文全称
    ,cn_sname -- 中文简称
    ,piny_name -- 拼音名称
    ,en_fname -- 英文全称
    ,en_sname -- 英文简称
    ,birth_dt -- 出生日期
    ,gender_cd -- 性别代码
    ,birth_pla_cd -- 出生地代码
    ,native_place_cd -- 籍贯代码
    ,nation_cd -- 国籍代码
    ,ethnic_cd -- 民族代码
    ,poli_face_cd -- 政治面貌代码
    ,reli_fai_cd -- 宗教信仰代码
    ,marriage_status_cd -- 婚姻状况代码
    ,highest_edu_degree_cd -- 最高学历代码
    ,highest_degree_cd -- 最高学位代码
    ,grad_sch -- 毕业院校
    ,reside_status_cd -- 居住状况代码
    ,join_work_tm -- 参加工作时间
    ,work_corp_name -- 工作单位名称
    ,join_enterprise_dt -- 加入现单位日期
    ,corp_blng_indu_cd -- 单位所属行业代码
    ,corp_prop_cd -- 单位性质代码
    ,unit_addr -- 单位地址
    ,corp_loc_zipcode -- 单位地址邮政编码
    ,profsn_title_cd -- 职称代码
    ,duty_cd -- 职务代码
    ,career_cd -- 职业代码
    ,sala_acct_num -- 工资账户账号
    ,sala_acct_open_bank -- 工资账户开户银行
    ,ghb_emp_flg -- 本行员工标志
    ,emp_id -- 员工编号
    ,ghb_shrholder_flg -- 本行股东标志
    ,auth_mode_cd -- 认证方式代码
    ,safe_rank_cd -- 安全等级代码
    ,invt_risk_pref_cd -- 投资风险偏好代码
    ,risk_ablt_est_org -- 风险能力评估机构
    ,risk_ablt_est_dt -- 风险能力评估日期
    ,raise_cnt -- 供养人数
    ,family_anl_inc -- 家庭年收入
    ,family_mon_income -- 家庭月收入
    ,indv_mon_income -- 个人月收入
    ,indv_year_income -- 个人年收入
    ,car_brand -- 拥有汽车品牌
    ,blkl_pty_flg -- 黑名单客户标志
    ,up_blkl_dt -- 上黑名单日期
    ,up_blkl_rsns -- 上黑名单原因
    ,blkl_src_cd -- 黑名单来源代码
    ,prefr_cont_mode_cd -- 优选联系方式代码
    ,bank_res_tel_num -- 银行预留电话号码
    ,crdt_pty_flg -- 授信客户标志
    ,small_eown_flg -- 小微企业主标志
    ,open_card_typ_cd -- 开卡类型代码
    ,pty_level_cd -- 客户级别代码
    ,real_nm_flg -- 实名标志
    ,co_brand_pty_flg -- 联名客户标志
    ,insd_and_otsd_flg -- 境内外标志
    ,assoc_txn_flg -- 关联交易标志
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_src_dw_pty_indv_party_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_src_dw_pty_indv_party_info exchange partition p_${batch_date} with table ${iol_schema}.rsts_src_dw_pty_indv_party_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_src_dw_pty_indv_party_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_src_dw_pty_indv_party_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_src_dw_pty_indv_party_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);