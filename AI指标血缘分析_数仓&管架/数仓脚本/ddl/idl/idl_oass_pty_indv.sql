/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_indv
CreateDate: 20241012
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_indv purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_indv(
etl_dt date --数据日期
,pbc_cust_num varchar2(100) --人行客户编号
,indv_en_name varchar2(375) --个人英文名称
,birth_dt date --出生日期
,birth_addr varchar2(150) --出生地址
,depositr_cate_cd varchar2(10) --存款人类别代码
,party_name varchar2(250) --当事人名称
,indv_bus_flg varchar2(10) --个体工商户标志
,indv_bus_cert_no varchar2(100) --个体工商户证件号码
,nation_cd varchar2(20) --国籍代码
,marriage_situ_cd varchar2(10) --婚姻状况代码
,nati_place_cd varchar2(500) --籍贯代码
,resd_status_cd varchar2(10) --居住状况代码
,nationty_cd varchar2(10) --民族代码
,taxpayer_idtfy_num varchar2(500) --纳税人识别号
,real_name_flg varchar2(10) --实名标志
,tax_resdnt_cty_cd varchar2(500) --税收居民国家代码组合
,tax_resdnt_idti_type_cd varchar2(10) --税收居民身份类型代码
,sm_bus_owner_flg varchar2(10) --小微企业主标志
,sm_bus_owner_cert_no varchar2(100) --小微企业主证件号码
,sm_bus_owner_cert_type_cd varchar2(10) --小微企业主证件类型代码
,gender_cd varchar2(10) --性别代码
,name varchar2(150) --姓名
,degree_cd varchar2(10) --学位代码
,blood_type_cd varchar2(10) --血型代码
,ctysd_contr_oper_acct_flg varchar2(10) --农村承包经营户标志
,farm_flg varchar2(10) --农户标志
,have_work_unit_flg varchar2(10) --有工作单位标志
,post_cd varchar2(30) --
,title_cd varchar2(30) --
,resdnt_char_cd varchar2(10) --居民性质代码
,rg_cd varchar2(30) --地区代码
,emply_flg varchar2(10) --行员标志
,dist_cd varchar2(10) --行政区划代码
,resdnt_flg varchar2(10) --居民标志
,nati_place varchar2(750) --籍贯
,age number(10,0) --年龄
,owner_type_cd varchar2(10) --业主类型代码
,politic_status_cd varchar2(10) --政治面貌代码
,ghb_rela_peop_flg varchar2(10) --本行关系人标志
,health_status_cd varchar2(10) --健康状况代码
,spoken varchar2(150) --口语
,sys_in_cust_flg varchar2(10) --系统内客户标志
,cust_lev_cd varchar2(10) --客户级别代码
,tax_stament_flg varchar2(10) --税收居民取得自证声明标志
,indv_party_type_cd varchar2(10) --个人当事人类型代码
,hxb_post_type_cd varchar2(10) --在我行职务类型代码
,grad_school varchar2(750) --毕业院校
,crdt_cust_flg varchar2(10) --授信客户标志
,main_type_cd varchar2(10) --境内外标志
,tax_num_null_rs_descb varchar2(4000) --纳税人识别号空值原因描述
,indv_bus_cert_type_cd varchar2(30) --个体工商户证件类型代码
,loan_card_no varchar2(100) --贷款卡号
,soci_secu_card_no varchar2(100) --社保卡卡号
,provi_fund_acct_num varchar2(100) --公积金账号
,agent_open_flg varchar2(30) --代理开户标志
,referrer_type_cd varchar2(30) --推荐人类型代码
,referrer_num varchar2(60) --推荐人号码
,obtain_emply_situ_cd varchar2(30) --从业状况代码
,open_acct_chn_cd varchar2(30) --开户渠道代码
,legal_en_last_name varchar2(750) --法定英文姓氏
,legal_en_mdl_name varchar2(750) --法定英文中间名
,legal_en_name varchar2(750) --法定英文名
,career_cd varchar2(30) --职业代码
,other_career_name varchar2(750) --其他职业名称
,share_ratio number(30,8) --
,shard_type_cd varchar2(30) --股东类型代码
,ctrler_type_cd varchar2(30) --控制人类型代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,party_id varchar2(60) --当事人编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_pty_indv to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_indv is '个人当事人';
comment on column ${idl_schema}.oass_pty_indv.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_indv.pbc_cust_num is '人行客户编号';
comment on column ${idl_schema}.oass_pty_indv.indv_en_name is '个人英文名称';
comment on column ${idl_schema}.oass_pty_indv.birth_dt is '出生日期';
comment on column ${idl_schema}.oass_pty_indv.birth_addr is '出生地址';
comment on column ${idl_schema}.oass_pty_indv.depositr_cate_cd is '存款人类别代码';
comment on column ${idl_schema}.oass_pty_indv.party_name is '当事人名称';
comment on column ${idl_schema}.oass_pty_indv.indv_bus_flg is '个体工商户标志';
comment on column ${idl_schema}.oass_pty_indv.indv_bus_cert_no is '个体工商户证件号码';
comment on column ${idl_schema}.oass_pty_indv.nation_cd is '国籍代码';
comment on column ${idl_schema}.oass_pty_indv.marriage_situ_cd is '婚姻状况代码';
comment on column ${idl_schema}.oass_pty_indv.nati_place_cd is '籍贯代码';
comment on column ${idl_schema}.oass_pty_indv.resd_status_cd is '居住状况代码';
comment on column ${idl_schema}.oass_pty_indv.nationty_cd is '民族代码';
comment on column ${idl_schema}.oass_pty_indv.taxpayer_idtfy_num is '纳税人识别号';
comment on column ${idl_schema}.oass_pty_indv.real_name_flg is '实名标志';
comment on column ${idl_schema}.oass_pty_indv.tax_resdnt_cty_cd is '税收居民国家代码组合';
comment on column ${idl_schema}.oass_pty_indv.tax_resdnt_idti_type_cd is '税收居民身份类型代码';
comment on column ${idl_schema}.oass_pty_indv.sm_bus_owner_flg is '小微企业主标志';
comment on column ${idl_schema}.oass_pty_indv.sm_bus_owner_cert_no is '小微企业主证件号码';
comment on column ${idl_schema}.oass_pty_indv.sm_bus_owner_cert_type_cd is '小微企业主证件类型代码';
comment on column ${idl_schema}.oass_pty_indv.gender_cd is '性别代码';
comment on column ${idl_schema}.oass_pty_indv.name is '姓名';
comment on column ${idl_schema}.oass_pty_indv.degree_cd is '学位代码';
comment on column ${idl_schema}.oass_pty_indv.blood_type_cd is '血型代码';
comment on column ${idl_schema}.oass_pty_indv.ctysd_contr_oper_acct_flg is '农村承包经营户标志';
comment on column ${idl_schema}.oass_pty_indv.farm_flg is '农户标志';
comment on column ${idl_schema}.oass_pty_indv.have_work_unit_flg is '有工作单位标志';
comment on column ${idl_schema}.oass_pty_indv.post_cd is '';
comment on column ${idl_schema}.oass_pty_indv.title_cd is '';
comment on column ${idl_schema}.oass_pty_indv.resdnt_char_cd is '居民性质代码';
comment on column ${idl_schema}.oass_pty_indv.rg_cd is '地区代码';
comment on column ${idl_schema}.oass_pty_indv.emply_flg is '行员标志';
comment on column ${idl_schema}.oass_pty_indv.dist_cd is '行政区划代码';
comment on column ${idl_schema}.oass_pty_indv.resdnt_flg is '居民标志';
comment on column ${idl_schema}.oass_pty_indv.nati_place is '籍贯';
comment on column ${idl_schema}.oass_pty_indv.age is '年龄';
comment on column ${idl_schema}.oass_pty_indv.owner_type_cd is '业主类型代码';
comment on column ${idl_schema}.oass_pty_indv.politic_status_cd is '政治面貌代码';
comment on column ${idl_schema}.oass_pty_indv.ghb_rela_peop_flg is '本行关系人标志';
comment on column ${idl_schema}.oass_pty_indv.health_status_cd is '健康状况代码';
comment on column ${idl_schema}.oass_pty_indv.spoken is '口语';
comment on column ${idl_schema}.oass_pty_indv.sys_in_cust_flg is '系统内客户标志';
comment on column ${idl_schema}.oass_pty_indv.cust_lev_cd is '客户级别代码';
comment on column ${idl_schema}.oass_pty_indv.tax_stament_flg is '税收居民取得自证声明标志';
comment on column ${idl_schema}.oass_pty_indv.indv_party_type_cd is '个人当事人类型代码';
comment on column ${idl_schema}.oass_pty_indv.hxb_post_type_cd is '在我行职务类型代码';
comment on column ${idl_schema}.oass_pty_indv.grad_school is '毕业院校';
comment on column ${idl_schema}.oass_pty_indv.crdt_cust_flg is '授信客户标志';
comment on column ${idl_schema}.oass_pty_indv.main_type_cd is '境内外标志';
comment on column ${idl_schema}.oass_pty_indv.tax_num_null_rs_descb is '纳税人识别号空值原因描述';
comment on column ${idl_schema}.oass_pty_indv.indv_bus_cert_type_cd is '个体工商户证件类型代码';
comment on column ${idl_schema}.oass_pty_indv.loan_card_no is '贷款卡号';
comment on column ${idl_schema}.oass_pty_indv.soci_secu_card_no is '社保卡卡号';
comment on column ${idl_schema}.oass_pty_indv.provi_fund_acct_num is '公积金账号';
comment on column ${idl_schema}.oass_pty_indv.agent_open_flg is '代理开户标志';
comment on column ${idl_schema}.oass_pty_indv.referrer_type_cd is '推荐人类型代码';
comment on column ${idl_schema}.oass_pty_indv.referrer_num is '推荐人号码';
comment on column ${idl_schema}.oass_pty_indv.obtain_emply_situ_cd is '从业状况代码';
comment on column ${idl_schema}.oass_pty_indv.open_acct_chn_cd is '开户渠道代码';
comment on column ${idl_schema}.oass_pty_indv.legal_en_last_name is '法定英文姓氏';
comment on column ${idl_schema}.oass_pty_indv.legal_en_mdl_name is '法定英文中间名';
comment on column ${idl_schema}.oass_pty_indv.legal_en_name is '法定英文名';
comment on column ${idl_schema}.oass_pty_indv.career_cd is '职业代码';
comment on column ${idl_schema}.oass_pty_indv.other_career_name is '其他职业名称';
comment on column ${idl_schema}.oass_pty_indv.share_ratio is '';
comment on column ${idl_schema}.oass_pty_indv.shard_type_cd is '股东类型代码';
comment on column ${idl_schema}.oass_pty_indv.ctrler_type_cd is '控制人类型代码';
comment on column ${idl_schema}.oass_pty_indv.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_indv.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_indv.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_indv.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_indv.lp_id is '法人编号';

