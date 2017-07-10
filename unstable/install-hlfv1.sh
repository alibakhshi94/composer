ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.9.2
docker tag hyperledger/composer-playground:0.9.2 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��cY �=ks�Ȗ���{gu+{o�����~�!�q2@g<5&�a�����
р��4z�q������q?��ؿ�U��-�a��3NՌI���ӏ����M]�B3(�=C�`�P�a�����'4�h��#1������4���0:�0\,�f��~�j�Vp,[2xb�R_�n�[���>4-E���.�KQ4���}��[�>����ْ�A�\�zp�K2���Fi��M6����}K���i[n� ���G����4��S�zP�GH�b��X���b!��샟� >�h�vR�4(ۨSǦ�RT���ڒ�"~���gQ-���J��<<7���dɦb�&0��d�@�}&Dϗ��Ws�����a]R+�n�pG���C㱗M�D#�H����u�F n����&4��@��f���H���bbڦ!��^���z�
1M�1��sE�gR>��"w$4Q��Q�FIs�=�Ȧ0f�l3���<�,-��	��6���Q��ss�����2�ݽ�#ǀk��	u�e��9�`�:���/R�e�j�挺)�z��|r-V;F�	͞BبP��*bj~j��a7�EM~i��f�H%O���^���$u$��%߹�K=���#l�~���V����0��,�!<�Cv��?8%����߆������BV�m���o�4�x���p,E�������<�.�P�pC�:��;�A�� 7ɟ�bb��~L���J�VN�����2 ���&�>Wu	�{�X~���˃��yO��?���&`��_6,�C��h;��t�A� ��F���Q��l�cx�f����l��F o������@�X�I�Q����Y�Th�
I���<�6X��CQ iM�� -�Dۮ>Tu�}��i��pL���0L�/٘F�t I����3N[Ud�Y�GZ�d݌.��^s��$T]��	���d�������PC�VY�9�F�%KAYUݸ9ԝ�T�#�F;�1��X؅��-��+�q���s�f_�GQ�Aɔ;J��h;��A���@�]�a��yR����`L�x$�P�S��+��bB��Y�f��r�39�2�,i�����n��	��"_�k.��X�K�?�Ģ�	鄭����?��Vh9q��#٠��*�&��}�!0MS��䣀E�Y�n�xI}��c����&YB��@�ח���5y� ���q��P�� p���uK���v |���h��5GU���m��Ij�Z
j��n\����zwr��*͚=@*�n��bz<����WH@T�x�\2f��=���m9�n��V0�>��
�H�N�<��;��ļ�t\ �Y���Iz�ї�V���
�5uH�7�:� }ӟ��Ź�+l�z�UAՕ�&�0�M��4P.u\��U(YXP��E� �X6�g�ܟ���8���6x�A�� n,��*j@��y��m�^#"�/j���g쌞m�%a�� 4L(u_�� δ<Ft���|B����CK������b�Ra�����|?���D���������ˆ�?��jc��?��"��a�-�o\;)5q��֙�r �d驳�6�L]P��͘R�5���5 ����R�l��Kf+�d9{\=��M�+F��Yveog�����z�D����r�B��M���r%[,�����͞�;� 8����n9=܀���/q��.p��PP���u��V`��t"�T��T�r���͋�Z�f���������d5��s]�*}��n�]hݿ��������,D�w��;�|a��M>| �-	1.o$u�).��5� ?Ͼ&f)`pY<&K::;�Sް�E���u �8ϋ�.��^E�/G�-��2�9�p���"��ֶ�X�.��#����lX���L�!7���?�г������<<�S��j�=ӌP44!�
�AÄ-���8�xL��ٷR�ް��g����~�g������M����;:��:X&�����,�l�����=,x�������Gxn�����+�]���=�i� ��n�S�l�h�'iM+D�x�o����� B�V:�M�쑺�Jb�α��{ G!��S�A�\c!<��O7�_�Q���a�N�)2jZ�����BICY�/��:x�X6�����d���`r^�N�Qf����(�-�Ue��(^���MN� ���_�������y�g�-�o>W��#�/���\�U%�� �;�� ���.�?��1Fu�^�Eϣ\�1!zT
7�r��1]j��Y����Yx������?�m�#�I���۹�ѭ+`X��ˢ�ʋ�^s�6����4?��gx����&��3/b��C�1i>4�[��]����ςK�?v���?����	�����?�+"�]�@�� &U���z]d[���&	�,�য়�XL���%�B�Qޑ�%.��1=�C��bT��v�/�PuYR;�e��!W�܂7>�Cn�8t��FF�3W�<�xX̋׷��B���DR�����S?��׻ПɠL���И�����e��F�#Y���Mts��n:BF�i2���5���۫̚����c�(?�����V�o<�d�e|�͂{���0�����
�],����u/�;�}0U`��^�h^�'�r�\O�'�s�'�DNL�c� P}���,,D���v})������������d�,��b�\H��b�"ԪŔX�UB���G=I��ꁣ)�H
���6�㣐����䊙L��9ωu1w���\�������칈�v��Q<)���a�*��W�d����NM��b.�z�}W�3]��B�,�Ճ����U��Ѩ"lUѺ�	�Zj�hu@P��
��� /��M�KƳ��U���,���E��ʹ��������Eg�?bí��|��?b7�?�U��)�7؅k}7@�� $���������ѭ!j��&�w@����Xŀ�Ƈ.�Q?�
 �����"w+��^�~��ǫ�?s�(��?X�Ƴ����n�?6���}.�[���֛�|�?�n��F�s��{��Ґ:��x^)����0�u"��v�!�lE7�-{���k�\U#c#v� ��?�?s� fn���W{%n�1`U��K����،�G���#����O��� ���.Sf������P�]ʻ4}��tG�4�������K!����%翣4��X���7����!Hn��)�c"����m�9�/!�hU��ϡ�%���|������r���ߛ����'��a�(wi�<�C��m@�� �|�z������G0)E����P�7z�(w�V����Kc��,|��`
�!΀xOlx��x��̾�2� �_Y��ʵ/Bb����E>��0�b\d�)3��7D�]�Kh��'nnz��������-:��o�-~���I�;�����������	X{�'B�O!�rY��y.:3��v��!���k���������������yF����4h����^Kfd��K�F�����h�g96&A��\��7�N��8�3���6�x~������+j���οQCU������;��詷�'�>����Y�i+No�_w���)�I�������t5�o���(�-��v�����v�ѿ��5��㉩�h���y�)���q�+C|Ä/�K���a5"{�o����X�k������[��������[��%򟝟.����|��X��[����;�����Qq�ɏ�����>�@�PC�*��@�>�����ǀ���7.K6>��0'IƢ�-��"�^k/[2�ؓ�����5%Z�p�,1{1)�`b��8���&�qm2D���u �NCB�d )���t6)TE��^�g���E2)�ɶ0�&�v�,��V/�6É�PSt�����i�H?�^]�"��Wb� t3S�|�^�_�WB9�.�QU�d��id�^#�ƑN���Ps��j���D�&���)�^��{������Ыb&><�����N�m�:����<L	�����l��^��b;r!_���,��f�b5˞��F���k'�F�d���T�Tʈ�7�ڕXͣ�ýK&�G%6mI'g}���U�$�(�=���k56�dų��	!�-\4��V>Aa08)��m��Xh�
��Lږ3�j�W�7��34��|&1�5S�sq�-f�I��@<謐�8{G����^V������
o�ӣ�ގ��8���o�Z�{R���Z�T:��R��(|>v;3��B%�����r������ZM����Q�L�DxP�s|�N	y<և�|Bh� ��U3;(u��#!��g�Kd���Y�uG�_�‬T,�t2�+���r'/�㞡L
t[ȋ�d��䬣R���ۿ6���ۓ���I<���^�RYV��ڠ�'��v�]Ꮲz��f��ӺhHbv��ǜ�{�m=x,��0��c�f�V�kdɋ��6\__�¡�/9]k��Sŵ��?��3iƽjl���O@��3#�o�}޲��(�Q��Wv�N���-lh����#љ�����	��I��l)p$��ԧT>�9D:Y�MG'2�@�6T�Ԧ�� �K�J8�tѧ�YQ���-,dNT���SP�*�4�� �+)e���J�B��׺Wi){uU�zIUՀ��W�ֆ�2?��*�k�C6�������N��BV��p��s��*{0�����Sj���;�أ������y��o��&�����x�o���������l�����e�~��������H
��+$%��T�-�Rl`��TM����/O�N�b���!�"O)��>K�"����[��.�;�.�u�9:�u�l��i���Y����Z���RB�����g){�Q����h�:,i)��PZ��%��q���?�����x��14I�d6�G�2�T�q�ʐ��f�z�c1�So�9�}���m)�����C4�C���T[��F Ͷ A��-ESHĔ��Q]��\��z�&��5^�9�m=0I>z�����5�	���ԃ�� H�=I���/���?t۸�@ŀ2��
� v��P�$	����D�RF7R��n�o�<�B�w�U<��ࡗ���O�~��']��������&ƕ#�'�(��D~��°
�D��������>)�����=�è��n������ݶWO
W�E�ZXĉN��.H��Ю@	� G��TU���|��7q�yvuտ������_Um��[|�~k�@�Gk�MW�M�����ͅ��	U$(B����B��.=�Q[S,W$)��㖁��6��h�1>�&�M����6:\:��h� �`:T!J��2��l@������PQ�`V��I�*4�շ�74�$��sK�Ӌ'ds�����BY>'06��~Ѡ�d!���#�+�d �	nrPN1������c��*���|��|�Y��Y���_�;���>\�ؕ���~�������#�ϟ�]IĽ�XD�`���3�Y����>A}�I�T�P�*���99��	���-�M��vs����ԑ3(ڂ܃)�`~��G捦P�D07����W��N��\�-�[��lm����/�ϸxx��v���=�n@(�#}*��o��6�#���K�u�࢖h�>�ա� ��-�9�"��dukl>�<���t~��^�V:7�bOH>ƅ�|�l Gr���ǒ<'�#B����n��o�ч�"�dN����G����'k*X֡f��oIt�!b�T|d�b4*=�2�A[��3X&E���\���d�j�2�D���ˢ��ˆm����V}z��=]�T��'�i��8��C��FG��Ʉ��Rhݪ�2����W���0�+&��N-�-_�]4�$�V�z�A�Bo$	k�)<������n�5����y=�q jם�u�����"���2M~=�bo������?��?��|��?���|���/��������)�)�7)bA����￾���_`���hG6>�B�>�"�'2RT����$'b�H<��d?I����D%� IQ�Q�D"����@B��q)-�B������������}��g�ο����z磯��oE��GB�	����+d���B��`�6�����{�����> ���~� �/B��`�����j�1F �X����E�2H�[��V��qֲ�>b�|0<�Tk5�>c�`E�a�᫈ ��+0=��@�mVq=���\hv��El�H�9;2//�p֙g��p�0m���4B(��.: �N�֎�B]�9�k<gO�N{>�2q��z����Y���&�B\���qT����P�9g8���o^�;m��-�͘Bݶ�
��ܼ|�i$�g��Z51�E�d�a�á��/��f$���R��	�n�w&��4���N4C�M:W)�����P$�\�<kP��L��[I�11 徐��,jf=R�k�0CñW�#�Nc�X�G�;y�ɡ���8s��ܲi�>[��:��9^�)y`j�)�S
Q����98�b����Ɵ�Rg<�&��M�"[�$�4�dӳ��:3���$晴�XVr��L�YC걝�Q�R�|�D�I0k7Zf�Ώ��l"&���9�������>6����u���k��.�K��K��K��K��K��K��K⮸K⮰K⮨K⮠Kb��
�`�%�l�h�-�7�,��ZEi�����n���4�z�9[R�r������ۉ�����΅���/	�{��z�(:�v=�=�s=i� + ����݈X���!<�s2�/�Ik��SE+6g���.U��j��n�zgm���L�J�5��I�Vω����\Ļu[�2Փ)�'���Z�z�Cx��E�O�����,��G �iq���5�x�賥M�R��c�ڹ}��)хY<S���e�25�'��]1�k�Ɲ��Q��YLS�a��OJ)z�j��0*s��ѱ�lu[�i�JH�>��~?;���#�
-�u�f�EV�������C�B;���o켶�6�����n���{�nV��8��0�l�ˢy>�VuM�-B�����Fhǣ��(����l�.���}�oS(���f��k~.+��#�Z���G��~���
��7w�����A�w�~�����ZSVZBS&��������4T�ʴe.U?IJ����/���X����ltS�{v�1,,g'��c�E�&j���,q��9h��t�lNqM�mnZ��iy���o0B!P��n�MF�΂gV�C`A2k1�lj̒�RV2�,��;��d5ޞI�U��"��)쫣H��zI:;�1�����t��<劊�O��:����&]q�L�x�AǳHN�Q:�N�t50M�BX�bY�X��2Y��r�2tXQ�V?��=�O�L��ϡ�/�N���4�.�#b�Q*��2��ꉼVO�"��F�c*ҔOR��IFJ$!�k�hز{BA�h��Qc�Tx���A\����q�͟��/h��t��ë⁽_�Vi�(P�@��)�y�5�	V�ĥKC����?y���%0���K�rnI{2;*<�H�Z��O�&�΢|�-��pQ�t��;i��f�q%O݉�껧������<��b[�j���p"8�\c�3�4�v�j��UK�h'o4��q�����\
��j�5���ܐ�L�$�]�>�f(8�:��Uz�V�g�p�L'��rY��-.\��ve�	��M�G���1ٚ���ͅ��Ԫq^��3E�[������鄞BD��9�d�EႫn@��?�`�N�U9�=�����ْ&\���	&���8�
\a^�7��(l3����a���\�������5,F�H���%�tqY{�B1�_]��&r$��#ʳQm2>QS�@e��4 1�BTb��u$���]G2�y�F�v	F��ؙ�]��	����t& N�<gRG��P����z��(�c��q�(;�7�Z���đ�q�)��'\֠��hz֭5x%�-��
ht��)��Y��I��ҏ���L[3�H/S�Qn�Pϣlq(�V��<��3����2U7�vM)�Zb�L��{���PhnX^ߡ0�AIm�J�5qnQ	�Mw���If^�g#"�E2�7���Q[a�؍y'b��hLrn֖�.f�ڢ���ڙF��*�U�䇥�U��8��wq黡w��[���޼P�6o\Ə�?"�a��4�3�B��$ވ^��_&��j]6̩�8��~����+��h.&r���[ě���~�=��qu)����!����/���������֣���y<�<�8("���Ň�M�y>#�c�+�c���s`�e�|>}B�_ �@+���0�`�B{�5�~_���i��n�~�iM1kv�~�������В4�C6B��.�
�MǇz]:yiܹ�H�\�!^s���s��-��!<�9���y�I�.���}}��+������_��Oz7M�����������5��wʝ�A�L���|����=<L2\t��I���)�&>T�9ғvEF<]Cվ�~ywg�l�ؼ�}um���J@��|���}�:�
c-C%�.]/Kb>~�Z��^������"�kj�ku��>Iǿni��z�l����&�����/�n8����v�2�"A@���?������ba�05(�S�Am@��)B���݃�އ�o���� >���$I��.�5pw�	I�&itK�ȱ}�v��T�����K�L�`���Zc�tX�4��3���>٢�����Z ��p�p�.{�}�C�X���
��dM�`p�"B��~5.@�g��B75`����XI=��$`� 	��U���&纐	0n�����5��9�ɵMCa�o�JP3<2&�����H,S.|��{������:U�=u�C��C��-��jP���p"�r����k?�7�����9�ݛ7o�w�i��S��`��~|�6
�]��������ί(�$S�0�Y�
��N���ص��| D��M��i4���E��hy!�;�.��Ā7/1�X|��C��k��!�E��y��Tu��Dgߟ��M�R^m��׸8s��@�����0>�)�O1�u�aK�nɚ�F�����6N��r�����M&�ʁ�����2�R����(cC=��lƀ% �Zt�Ø޽!��;u�pj@Y����v�:��f�^s�2鮕8�#���F&�v��CQ��j�P@��,�\p9$��:u�J�⬱9�5c|=�M�7JajX3��^�4�<
���S6����:�F�*�d'�t����c��.5�	�F������ZfaB&;���/�+�\�{�v��A�l�<U��%���j���ĹU��݊3iR`�����ml�h�����G�^2���Xo:Nǌ{�(���1
*T� �5"k�v����wvŐ%�\�!=9��L�!r���j`��yH�y�{ 3���Q�F�P����䫇�vh�_�M��6�4M��s��L$]Y���<74򚨣��N��%p���N(M�D�w1�n�-n�0�M[�]��)�t��~�ոp���g��'�f��5����p�_�����]���:����H%6�K�#_���J>hıB|�� ��='*�r�c+�Ek�7�'��zV��s4S糧Y�]��,,���V��`n)����\}+ӐĖ_U
�>��T������N�=���Tt�u^��J�K$�( b"��� �c�~2����>%�� Q1��D%�/�3I��eM�Sc�X3��;���5+�]+8ͽ����i��t�=N�K>�)�����bˀ�sh�ŋ��2@L&�(��x:���DE�x/2 �d2��S�t2-ǀ(�{$@r2���)�I CƐOE��C�wb�O�O17f0x�v�_x��Û���&�Sg��6)��M��ߒ������Ku�Rg�:�<W��t�Tɗ�c��L�EK�<�hre�e�\��,��ȥ�ѿ�!p�B�}���ɺ]Ǽ5�K��]ѩ,]U�}X(�.7���BF��[��+,���pnv*�u��>1Ê�V��ƴVTs`�X�.غ�zGUl�v4ytf�[�ۑ�k-�.�yF��#b��Z79k߾T�]�XV�\��z��g+uIz�/�O�Wߐv�<[��r�®r:��rL+���X8��l��Ϭ�:?��h�ux��5vC�#(��$���啋I����]�R�Ҵ�6��=�E�F3[)���i�k�+�#�K��=���ޕ5��-�w���N݃��:UW @!�A/�4!�I��_���Đ�q�}�^.�`c��ګ{w���E���O:?���۲[��q.�;�yt�z�YǕ]��&��";���e�����j�Sk�������=R�$���w��/;���>~z�ʿ��,K�sS�.�e��u����/��}{M���z�H�{�5e[��ݧ����׽ڛ���]{���E���|^x7���/�3=]%�������{�;����_.��+�7i�?^�y~��C�.?T�'�4�?�?�6��5���́�yo���<���(濠�/����x�5޺����g������o_�2~��3��a�Q �o����&��>���β(x��P �X�w�?� �#�OS�K���P�����O��>-P���)�fn��ߑ �g�~�g~��Lѷ�O��ݙ��	P�$��s8LH�
bL�����82\��A$	"%�H�C&b8�	VLB2N(�����:?7p�����0�	��/�d����|X���b9�ʻښ(u��\3�-e��]�i��}����i�gR)��5?��a6�zm�������'�α���xB�A��2�ip��jc���M��lF���eH)����B��3���?�]����������������	�����?%@�p�����g��Q ��������_<����8A �G����R�]�G���_8���&��	0��k��D���_8�s�-����(��_}�U�耊�T������,��� ��9�0��_]��K�B�Qw�?��	0�Q �a���s�?,����� �G���C �?G�����(�Z�o_��d���S����(z���.�.�x�r��y*��32��S��{i�$~����a��w�~^Z?���~�y�a,�F���}>�}S�������iV2N��Q������,g��msw=Xe괵F���f�,�ʕV��uj�iH�N���w�u�O��??���}>�}?��Y�����i���;W^�9�׹|�d��m����`1�Vk��}��q3)ϼ�Vzjn��$θSi���M)]�jG���h�Rը�g������xێ\]��~�n밝n�*qu��b7s�Z� �����wm�@1���s�?,���^�.Q��E�������H �O���O��Tl�G�Ѡ�P ���S(�/
�n���?\��?��X���'A����!������j��{������=��>l�!O7�l�潥���W��}���?�����M��a=���~�]�VBI���gIo�Qgf����37����M���J��B���MC1ҜRO�&.ֵ?d[e��ȩ.:�e�zv�o��D6����=�)�y�!��(��K��c|��������vlc$7�1];�D��Dw?�Oyz�h�d1Ḿ�Q,F��U����<�[����Q*����+��R�d��<�I=����ݹ5���������G��C��49f��&�� @�����ϼ���_p��8�<)!rT�<s"�"Gr�&db(D�E���L�L�G#1!��0#��������~��vj���a�,��J��l����I:��Tb�ymR1��4������(��b�vF�P���/�郞v����Q��L�������|��a��4K���y�6�>&�8\�S.�nw�������8����Y
���38�-8���,��
�������?�O����;㿝e����^*���;C^^I�7mn�h1��I�9I��=�z��[zWM��Xǌ�K+�^�SyDsg���g�iJvҌ��K��:��,Wj�]�uz�ϳ�ݳu�l�e7�9���
<����?
��6�g�o �_��U�������� �����h�"������0��P�5����/����)���r���}�y�(}�7������?��W��8��ѯ�  ��� �k={w�Y�F��,��w�*q�� ���l�k��Rs�d�傞�S3$ڥJYi�s�YYLG�T�SD�R��m
����%���A�m�C.�g�fo&��]�'��D��w�]/}|����U/3 l���r�6J�W���$����@��Ӵ�X�}W�B�:m7�D9͉�E��b�Vf�^#3�����G�RR+e�����R�*���p;i �M�V�� �ݪR�]�)���QS���P3�b���.��&��<V&�TN�e�=�/϶�Yc{۵����XT�w����z(��h�����;������GTx�����y[�q��C������;�?���H�<��*��Y������?����������?Q��_��?J
B��0$Y�� �脍�@
���Y)H�&��4����X�VH��h��0��߫�%��	~g���
wӓ���|�4��C�ەՃf���Zw�o������_����U����sb'�raT}r����R�!sFi���|�o��>�[�ޱ˓���_�]��<Zj�6���w�"�y��
���3��?H����x(�]�����?�А�G,�����C�"��� ����G ����4}����?D@�������q0&@��?�����C�W��/翑�\�m�Z��U:�e�z\���R������TH��&O��:m��_���<F�J���(��a�w���^g�8��I����~Wwb��Tuzp\��l��?4zn�k#��q�Jmќ��¬�ACnT���9S��k��Ff������捉�*MSf���,W{�z��m-��Pέ�7~�C��M�9���j�$��ZR��昮s56v�U٩l�j�*�5l�P�t���������h���g���W�rj����s�~�����
t#7%a���Yk�������-�#c]��8迳ڃ���������ϭ�p��b��� ��(�8������C����o����o8���q�o;� �% ��������“���B `����e8��Q ����������;��$�?����]~i��p(��=�?�?���4I����?
����e��-����������!
�?���O��� ���?�C�������3��?� /�s�@��?��������?��ÿ��㗀���n�P���?�)�n���s7������C[H�!����������?���?��?迂��C��?��Â����0���`�X��w�X�@� �� ��b��;��� ���S(�/
�n���?\��?�G������������C�?����C�_�����(�(����&�l��$� ��?��Á����@�����b0$��d$�)E)Fl(FK3	Cq�dİdP�H!%��,'��}����gx
����U����s���>x����s�)�(U�d\r�����7�Jc9.K�i�~K��O�jo6��*Z�:{A�F�Re��٫��Y���MO�@J�.;Wg�R��۝zG����,�n���Su�[x���m�	DrY�vǦVs�d�(�hi�ϡ�͛*��8����Y
���38�-8���,��
�������?�O����;�vĘܡ�m�y��h��m�9L�ڤ�:��OV��a{�W�"x���d�uv��:��Vɥ7���g;��G$a�V��&�P1�eo�S�M�zV���n�M��b�U9�I�a��b����[���3�򿈀��E�?��7 ��/��*���_���_���Wl�4`�B��o�{�����_���W������˨=u�/���M���ڧ?\�U�߭���E�i���UjN��@�-̪�m�+7*���TZ�S��Q,k�76jYu�ƞ�6�Ov2�׈:ic�O��i+��LfY�q3�W��������2'n�]/}��/ץS/���WQrS9_%�+����'�I��,Т�VN�vbU�]EE����4OQ$�~�qZ��z��Y �M�V��p�����#M��~Ȍ����}�����vR�ڜ�y��~�P�,*N��m)�dz��j}����̴<\�8am����
�"�/7q�y��|�����,��Z��Q�#���﷮�W�?���?��Q��O��F������nP�-P����?KҰ�#�O����/��h����<=�*������2�w��(�Z��rUU�������۫E,�LJR��(`̛�<�~��GE��'��~yX�̫7�����Jg�{�~�����#�;��)�G<���\O�|����e`*�S�sI]^2���kے�+�J=fZ�9�j*J~)�s����QC]�2~�u��5f��.m�*9]�j&{���m�Hi�TrWT0�%g`�9eۤ,~�y����N�n?&��h��ļ�ʭ�#Z�ʻf߂��q�켬������&���~�����!�V6��5k�=VTE�w͔{�8�ABu�En��}�fs�IB"mCL֬�/�̩U�5E��
=j�Q�R����aGqq�'����K������j�R#U�^9Pr�0 w�<�M�?l���e��]ߏz���f-����=�������/"��Bȑ!O1A(E��i�DTp~��#iH��y�#�e�a�!q��$dD����Q�!����?�?��C��Y����P��۝����$t?��a{LvI��m����W����[��Z!�#W.j��ߊ���/��w��p�?�A�Qs�� �����a��j������A�!�k��������Vܷ�l�����҅N����M�/p������ۻ�fE�-��_a׫x�:|ydЎ�� �y��� dRA���{���y3�*oee����^@�����>{_ꄘz���6��|��~�_����?���Y�_}ݫ����C����W�h��sg\l0{���r��⪏��9=4�5�t]L�捲�b��Ӵu��]��C_���dê9=�\Q��W&���Z���������pv�E-��R���&R�펕��>�[{�����m"��~�33N��L��=v�	���C�g��D�0JC����:�L��ֺ�uGm�3lrc��5�W
��r{3D�������wE�q/��3A�?��:�t��c�J銟N'�(�0LM�T\��U,٣'`Y�)B%p*قWkp�}Gd���y�_�Ơ�G&���?�A���m�R��9ք��i��� �z����y����~_����Z�����{?�i�߯��1�Y��/Q{�����x��4�:<����y�?������,Y����`7�?C���	���ç����s���o�[-��������y��q����Z��}�������v�k��G��#�Ү�O��p��ק�f�l�/���œ�к�\!_�tu]�B�[W����嵅��֦�}_z[	/�u���R9��Q�L�^t��M��#�R8�w&�z��F����S�?���Y\�I���h�E�huח{�Wu��]tXz8�u:m!�S��`�l|��(\�?�m����u���cy�ZS�ئ�V�Gʖ�8���/3S{״x��[��w���%�}S�k��pЗm������3���P��h��e����r쪻E[h��V}DV��d���#k��)��a���
�cĈ�S۪r���7�eA����C�O&�b��U0��
��[�����S~Ȓ�!�x(����T �;@�'�B�'���?��5�?瀃�� ����_����C����
�B��7������L �ߠ����oP������/ݿ�K��!������$�6(�37�ߡ�gFȆ�o��aF(�������;����y�����������?���@����'�C]�����;��w�����Y� �u!rBV����?���P��?@���E!�v���� O�I!���������M����E������o�?$��2���P��?��?迬�ԅ�`�?��+���n(�C]��P����C�����	�����P�!���;�`�'��Bǂ�����c�B�?y���e�b�?���B���� ���!��qQ��Ѱ����k�F�� �??�������_�o����
��:MกiUfI�z�$z��5� uS]��*eL��u��MS����4��Th��އ���ã�_�o��������@�$fQ�)̯���`-�msm�;��a��%K<��:���j���-�>�}�W��v�s$;�Ju�&���:�pMbE�����.W�ڞ���I���D�ۍ�!���c��'k��K��(=Pn�����߳D!�q��^e��;����y���Qm��}��h���T�^0a�����!��?���oP����P������'�_>�)1���E����-�?N�ڄ�=b��8��f9��F0�;���wyf���5^���0Yw���h�jz�`;�u��ȥpt�$�N�JU<��L�Q��]�/���)����J�z�XK����P=�<�oE1��
�sB��>���8�#"��r�A��A��@�����#
��(�F��8�,�������Q�u;V�~hmՁY�8�������뿏�X�Dn!ᾶ�>Ӂ��sg����b2˵��i��0�;\D���n��6Yv5oVf�q��gf<-�3�ȹ��k�$�
3�����koԥ_Q��^�ǠG	͕V�vm����K��U�ȶ�.���p,\�&+�,A��z�9M!�s\�H��:��G�$9ND_�\���:�Xo�|�%�J�ɉ�YG`q�|�8���񾤋�Y#T�[l���9����8�F��b�T�8`��b�ΰ]�hwBj��H�qW�0��8����k��(���)�������r {Y|�_Z����`$�d�B�?s'�������ˋ�5�`N�����y�?��������@���&��= ����������L�;��j��X<"����s��N���f�"�?T��Y�������A�������P��qQ����������?� �+��l�W�����0��sA!��6����L����s���~�����;
��MO��襩����l�?�X����s�G�X�|]���9�#�0��~���rgmn|���^�~���my���}fO�R��=C\���#����❮��ڼQv\��p��N���z�Kqt\�lX5��+*�#��$M�E�6��������U5��:�Z;6�2?)3L�J�+[�S}.������3�D������8�{3I�G��u'862f��uy~ga���Cw=�u�����u7>��&�ڜg���(/^k*����f�'��׏�0(�����ܐ��{�<�xD�����������H���� ������_8��g�����������'a�''��>6�{(`�?��+�S�N(��9 ����!�?7|�������W���t�l�;r<�:Q:֨=�P��������X����Awݝ��i
�����!�zwb�p
Ȟ�T	�Y�몎��VQ�;l��C�+���E�谭���6v�2�QB��
ww�P_�d�5�? I� �J �&�Q� f�+[��l����2{�G��mH�� �3	��-����9`5����܎4+����=�ro��v�F�e͜��N���o�5
���;�_��W&�]�}h��H<&��l�W���w�?V���@q������VӤU]�UUcY�4¤0�&5�"L���5��uS�4)��ڨUbI��������Q�����������9b��!��֚/|�L$�<�;*����l1�*�Z4�Q�|��y*��3m�����V�?���Zo6���������v��B��Q^��=%r��p^N�"�	��tb �zت͠��[Q����\���	T���(���_~(�C�Onȝ�_� &f`�C�(��������O�������p�C��T�+��;�H��9�s��wW���'j7����d������x�9�?:�	5�*Fk#ty�x�}���u%M'=���6�On�	���#	��ފb��7�_C���r��u �B�A�Wn��/����/����<�?��A�EU@��/�i��,���kٺOO�C�D�2��F��݄t����K���_��\��(��p�n:کj��;�_V�8�O����k[4&��ȧ�F+�jQe�Mg��v+]�\�gJm5u?T�^]�;�.�Y������CR�ǩl���<��^�f<����ƩO0���X��6�y� r/a��y"�~�7�jU򢱦T���#�5��(��4%��#����O�b+���z1S6�C}*��r�þ�G��|V8�#��ӄ��(��K:�L��g{+Z!��ic-Nsdnc��Z-��)}��ZԲ�>=�	��Z��������y��	�?���6�����,������/�?F&���'H������e:����352J�^&�_�>��N��0���QId��̿�E�}�5~��7�#��cz�w~�5��Q�_~9݋T���	���n���}�m��������κ���|F�V=��\O�Fr�/G��'�/�_l��Z����_����x��>%����)���g|a���ϟ��x���?�����F������^�t�0*A��]�ǋJ�f�>1��-�'$4��;㐾G
T��FI����tC���	�˃_~��_%}YJ�Kvx�k$���a���;���b���O��������x��JΊ<��������9F�eB
��|�Pzg��~z���ݔ��������һez������J��ociA��H��m��	Is<]MN�5/��b;!�`�y�g�6	E���%'�F�SR�����Hn����ިA�I��Ռ�C�����w�oH�1�w�&Ww!����B{�{N���K�a��6��׆�����%�r�w����������\��F�HG폃�^��Q��l��.)�W7���]�K~b|w ��	��}{��Q��'���H��aJ|����Rz�Oo�Uz���o�e*K�OO���C�3    (�=ê/ � 