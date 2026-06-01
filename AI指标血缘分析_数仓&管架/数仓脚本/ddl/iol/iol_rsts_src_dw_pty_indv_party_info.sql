/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_src_dw_pty_indv_party_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_src_dw_pty_indv_party_info
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_src_dw_pty_indv_party_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_src_dw_pty_indv_party_info(
    pty_id varchar2(60) -- 客户编号
    ,etl_dt_ora date -- 数据日期
    ,open_dt date -- 开户日期
    ,open_org_id varchar2(60) -- 开户机构编号
    ,open_teller_id varchar2(60) -- 开户柜员编号
    ,setup_chn_typ_cd varchar2(10) -- 建立渠道类型代码
    ,pty_categ_cd varchar2(10) -- 客户类别代码
    ,blng_org_id varchar2(60) -- 所属机构编号
    ,blng_pty_mgr_id varchar2(60) -- 所属客户经理编号
    ,colse_dt date -- 销户日期
    ,colse_org_id varchar2(30) -- 销户机构编号
    ,colse_teller_id varchar2(30) -- 销户柜员编号
    ,pty_typ_cd varchar2(10) -- 客户类型代码
    ,pty_blng_indu_cd varchar2(30) -- 客户所属行业代码
    ,pty_loc_cd varchar2(30) -- 客户所在地代码
    ,non_resident_flg varchar2(1) -- 非居民标志
    ,farmer_flg varchar2(1) -- 农户标志
    ,indv_indu_com_acct_flg varchar2(1) -- 个体工商户标志
    ,pty_status_cd varchar2(3) -- 客户状态代码
    ,legal_name varchar2(200) -- 法定名称
    ,cn_fname varchar2(200) -- 中文全称
    ,cn_sname varchar2(200) -- 中文简称
    ,piny_name varchar2(200) -- 拼音名称
    ,en_fname varchar2(500) -- 英文全称
    ,en_sname varchar2(100) -- 英文简称
    ,birth_dt date -- 出生日期
    ,gender_cd varchar2(1) -- 性别代码
    ,birth_pla_cd varchar2(500) -- 出生地代码
    ,native_place_cd varchar2(500) -- 籍贯代码
    ,nation_cd varchar2(3) -- 国籍代码
    ,ethnic_cd varchar2(2) -- 民族代码
    ,poli_face_cd varchar2(2) -- 政治面貌代码
    ,reli_fai_cd varchar2(2) -- 宗教信仰代码
    ,marriage_status_cd varchar2(2) -- 婚姻状况代码
    ,highest_edu_degree_cd varchar2(2) -- 最高学历代码
    ,highest_degree_cd varchar2(3) -- 最高学位代码
    ,grad_sch varchar2(500) -- 毕业院校
    ,reside_status_cd varchar2(3) -- 居住状况代码
    ,join_work_tm date -- 参加工作时间
    ,work_corp_name varchar2(500) -- 工作单位名称
    ,join_enterprise_dt date -- 加入现单位日期
    ,corp_blng_indu_cd varchar2(10) -- 单位所属行业代码
    ,corp_prop_cd varchar2(3) -- 单位性质代码
    ,unit_addr varchar2(1000) -- 单位地址
    ,corp_loc_zipcode varchar2(6) -- 单位地址邮政编码
    ,profsn_title_cd varchar2(1) -- 职称代码
    ,duty_cd varchar2(3) -- 职务代码
    ,career_cd varchar2(80) -- 职业代码
    ,sala_acct_num varchar2(40) -- 工资账户账号
    ,sala_acct_open_bank varchar2(14) -- 工资账户开户银行
    ,ghb_emp_flg varchar2(1) -- 本行员工标志
    ,emp_id varchar2(60) -- 员工编号
    ,ghb_shrholder_flg varchar2(1) -- 本行股东标志
    ,auth_mode_cd varchar2(1) -- 认证方式代码
    ,safe_rank_cd varchar2(1) -- 安全等级代码
    ,invt_risk_pref_cd varchar2(1) -- 投资风险偏好代码
    ,risk_ablt_est_org varchar2(100) -- 风险能力评估机构
    ,risk_ablt_est_dt date -- 风险能力评估日期
    ,raise_cnt number(15) -- 供养人数
    ,family_anl_inc number(18,2) -- 家庭年收入
    ,family_mon_income number(18,2) -- 家庭月收入
    ,indv_mon_income number(18,2) -- 个人月收入
    ,indv_year_income number(18,2) -- 个人年收入
    ,car_brand varchar2(100) -- 拥有汽车品牌
    ,blkl_pty_flg varchar2(10) -- 黑名单客户标志
    ,up_blkl_dt date -- 上黑名单日期
    ,up_blkl_rsns varchar2(200) -- 上黑名单原因
    ,blkl_src_cd varchar2(2) -- 黑名单来源代码
    ,prefr_cont_mode_cd varchar2(2) -- 优选联系方式代码
    ,bank_res_tel_num varchar2(40) -- 银行预留电话号码
    ,crdt_pty_flg varchar2(10) -- 授信客户标志
    ,small_eown_flg varchar2(10) -- 小微企业主标志
    ,open_card_typ_cd varchar2(2) -- 开卡类型代码
    ,pty_level_cd varchar2(10) -- 客户级别代码
    ,real_nm_flg varchar2(30) -- 实名标志
    ,co_brand_pty_flg varchar2(1) -- 联名客户标志
    ,insd_and_otsd_flg varchar2(10) -- 境内外标志
    ,assoc_txn_flg varchar2(1) -- 关联交易标志
    ,data_src_cd varchar2(4) -- 数据来源代码
    ,del_flg varchar2(1) -- 删除标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rsts_src_dw_pty_indv_party_info to ${iml_schema};
grant select on ${iol_schema}.rsts_src_dw_pty_indv_party_info to ${icl_schema};
grant select on ${iol_schema}.rsts_src_dw_pty_indv_party_info to ${idl_schema};
grant select on ${iol_schema}.rsts_src_dw_pty_indv_party_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_src_dw_pty_indv_party_info is '数仓_个人客户基本信息表';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.pty_id is '客户编号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.open_dt is '开户日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.open_org_id is '开户机构编号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.open_teller_id is '开户柜员编号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.setup_chn_typ_cd is '建立渠道类型代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.pty_categ_cd is '客户类别代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.blng_org_id is '所属机构编号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.blng_pty_mgr_id is '所属客户经理编号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.colse_dt is '销户日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.colse_org_id is '销户机构编号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.colse_teller_id is '销户柜员编号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.pty_typ_cd is '客户类型代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.pty_blng_indu_cd is '客户所属行业代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.pty_loc_cd is '客户所在地代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.non_resident_flg is '非居民标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.farmer_flg is '农户标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.indv_indu_com_acct_flg is '个体工商户标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.pty_status_cd is '客户状态代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.legal_name is '法定名称';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.cn_fname is '中文全称';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.cn_sname is '中文简称';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.piny_name is '拼音名称';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.en_fname is '英文全称';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.en_sname is '英文简称';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.birth_dt is '出生日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.gender_cd is '性别代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.birth_pla_cd is '出生地代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.native_place_cd is '籍贯代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.nation_cd is '国籍代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.ethnic_cd is '民族代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.poli_face_cd is '政治面貌代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.reli_fai_cd is '宗教信仰代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.marriage_status_cd is '婚姻状况代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.highest_edu_degree_cd is '最高学历代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.highest_degree_cd is '最高学位代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.grad_sch is '毕业院校';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.reside_status_cd is '居住状况代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.join_work_tm is '参加工作时间';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.work_corp_name is '工作单位名称';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.join_enterprise_dt is '加入现单位日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.corp_blng_indu_cd is '单位所属行业代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.corp_prop_cd is '单位性质代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.unit_addr is '单位地址';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.corp_loc_zipcode is '单位地址邮政编码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.profsn_title_cd is '职称代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.duty_cd is '职务代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.career_cd is '职业代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.sala_acct_num is '工资账户账号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.sala_acct_open_bank is '工资账户开户银行';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.ghb_emp_flg is '本行员工标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.emp_id is '员工编号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.ghb_shrholder_flg is '本行股东标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.auth_mode_cd is '认证方式代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.safe_rank_cd is '安全等级代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.invt_risk_pref_cd is '投资风险偏好代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.risk_ablt_est_org is '风险能力评估机构';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.risk_ablt_est_dt is '风险能力评估日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.raise_cnt is '供养人数';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.family_anl_inc is '家庭年收入';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.family_mon_income is '家庭月收入';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.indv_mon_income is '个人月收入';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.indv_year_income is '个人年收入';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.car_brand is '拥有汽车品牌';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.blkl_pty_flg is '黑名单客户标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.up_blkl_dt is '上黑名单日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.up_blkl_rsns is '上黑名单原因';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.blkl_src_cd is '黑名单来源代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.prefr_cont_mode_cd is '优选联系方式代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.bank_res_tel_num is '银行预留电话号码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.crdt_pty_flg is '授信客户标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.small_eown_flg is '小微企业主标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.open_card_typ_cd is '开卡类型代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.pty_level_cd is '客户级别代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.real_nm_flg is '实名标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.co_brand_pty_flg is '联名客户标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.insd_and_otsd_flg is '境内外标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.assoc_txn_flg is '关联交易标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.del_flg is '删除标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_party_info.etl_timestamp is 'ETL处理时间戳';
